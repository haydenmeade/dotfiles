#!/usr/bin/env python3
"""
Script to download video/podcast content from toutenfrancais.tv using aria2c
"""

import requests
from bs4 import BeautifulSoup
import json
import subprocess
import sys
import os
import re
from urllib.parse import urljoin, urlparse
import time

class ToutEnFrancaisDownloader:
    def __init__(self):
        self.base_url = "https://toutenfrancais.tv"
        self.session = requests.Session()
        self.session.headers.update({
            'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36'
        })
        self.download_dir = "toutenfrancais_downloads"
        
    def check_aria2c(self):
        """Check if aria2c is available"""
        try:
            subprocess.run(['aria2c', '--version'], capture_output=True, check=True)
            return True
        except (subprocess.CalledProcessError, FileNotFoundError):
            print("❌ aria2c not found. Please install aria2c first.")
            print("Download from: https://github.com/aria2/aria2/releases/tag/release-1.37.0")
            return False
    
    def login(self, email=None, password=None):
        """Attempt to login if credentials provided"""
        if not email or not password:
            print("⚠️  No credentials provided. Attempting anonymous access...")
            return True
            
        login_url = f"{self.base_url}/login"
        
        # Get login page first to extract CSRF token
        try:
            response = self.session.get(login_url)
            soup = BeautifulSoup(response.text, 'html.parser')
            csrf_token = soup.find('input', {'name': '_token'})
            
            if not csrf_token:
                print("❌ Could not find CSRF token")
                return False
                
            login_data = {
                '_token': csrf_token.get('value'),
                'email': email,
                'password': password
            }
            
            response = self.session.post(login_url, data=login_data)
            
            if 'dashboard' in response.url or response.status_code == 200:
                print("✅ Login successful")
                return True
            else:
                print("❌ Login failed")
                return False
                
        except Exception as e:
            print(f"❌ Login error: {e}")
            return False
    
    def extract_video_urls(self, page_url):
        """Extract video/audio URLs from a page"""
        urls = []
        try:
            response = self.session.get(page_url)
            soup = BeautifulSoup(response.text, 'html.parser')
            
            # Look for video elements
            for video in soup.find_all(['video', 'audio']):
                src = video.get('src')
                if src:
                    urls.append(urljoin(page_url, src))
                
                # Check for source elements within video/audio
                for source in video.find_all('source'):
                    src = source.get('src')
                    if src:
                        urls.append(urljoin(page_url, src))
            
            # Look for download links
            for link in soup.find_all('a'):
                href = link.get('href', '')
                if any(ext in href.lower() for ext in ['.mp4', '.mp3', '.wav', '.m4a', '.webm', '.mkv']):
                    urls.append(urljoin(page_url, href))
            
            # Look for embedded players or JavaScript video configs
            scripts = soup.find_all('script')
            for script in scripts:
                if script.string:
                    # Look for video URLs in JavaScript
                    video_patterns = [
                        r'["\']([^"\']*\.(?:mp4|mp3|wav|m4a|webm|mkv))["\']',
                        r'src["\']?\s*:\s*["\']([^"\']+\.(?:mp4|mp3|wav|m4a|webm|mkv))["\']',
                        r'url["\']?\s*:\s*["\']([^"\']+\.(?:mp4|mp3|wav|m4a|webm|mkv))["\']'
                    ]
                    
                    for pattern in video_patterns:
                        matches = re.findall(pattern, script.string)
                        for match in matches:
                            urls.append(urljoin(page_url, match))
            
        except Exception as e:
            print(f"❌ Error extracting from {page_url}: {e}")
        
        return list(set(urls))  # Remove duplicates
    
    def find_content_pages(self):
        """Find all pages that might contain video/audio content"""
        pages = []
        target_url = f"{self.base_url}/liens-des-videos-et-de-leurs-ressources"
        
        try:
            response = self.session.get(target_url)
            soup = BeautifulSoup(response.text, 'html.parser')
            
            # Look for links to content pages
            for link in soup.find_all('a'):
                href = link.get('href')
                if href:
                    full_url = urljoin(target_url, href)
                    if self.base_url in full_url:
                        pages.append(full_url)
            
            # Also check for direct video/audio links on this page
            direct_urls = self.extract_video_urls(target_url)
            pages.extend(direct_urls)
            
        except Exception as e:
            print(f"❌ Error finding content pages: {e}")
        
        return list(set(pages))
    
    def download_with_aria2c(self, urls, dry_run=True):
        """Download URLs using aria2c"""
        if not urls:
            print("❌ No URLs to download")
            return
        
        # Create download directory
        os.makedirs(self.download_dir, exist_ok=True)
        
        # Create aria2c input file
        input_file = f"{self.download_dir}/aria2c_input.txt"
        with open(input_file, 'w') as f:
            for url in urls:
                f.write(f"{url}\n")
                # Add referrer and user agent for each URL
                f.write(f"  referer={self.base_url}\n")
                f.write(f"  user-agent=Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36\n")
                f.write(f"  dir={self.download_dir}\n")
                f.write("\n")
        
        print(f"📝 Created input file with {len(urls)} URLs: {input_file}")
        
        if dry_run:
            print("🔍 DRY RUN - Would execute:")
            print(f"aria2c --input-file={input_file} --continue=true --max-concurrent-downloads=3 --split=4")
            print("\nURLs to download:")
            for i, url in enumerate(urls, 1):
                print(f"{i:3d}. {url}")
            return
        
        # Aria2c command
        cmd = [
            'aria2c',
            f'--input-file={input_file}',
            '--continue=true',
            '--max-concurrent-downloads=3',
            '--split=4',
            '--timeout=60',
            '--retry-wait=3'
        ]
        
        print(f"🚀 Starting download of {len(urls)} files...")
        try:
            subprocess.run(cmd, check=True)
            print("✅ Download completed!")
        except subprocess.CalledProcessError as e:
            print(f"❌ Download failed: {e}")

def main():
    if len(sys.argv) > 1 and sys.argv[1] == '--help':
        print("""
Usage: python3 toutenfrancais_downloader.py [--email EMAIL --password PASSWORD] [--no-dry-run]

Options:
  --email EMAIL       Email for login (optional)
  --password PASSWORD Password for login (optional)
  --no-dry-run       Actually download files (default is dry run)
  --help             Show this help message

Examples:
  python3 toutenfrancais_downloader.py                                    # Anonymous dry run
  python3 toutenfrancais_downloader.py --no-dry-run                       # Anonymous download
  python3 toutenfrancais_downloader.py --email user@example.com --password mypass --no-dry-run
        """)
        return
    
    # Parse command line arguments
    email = None
    password = None
    dry_run = True
    
    args = sys.argv[1:]
    i = 0
    while i < len(args):
        if args[i] == '--email' and i + 1 < len(args):
            email = args[i + 1]
            i += 2
        elif args[i] == '--password' and i + 1 < len(args):
            password = args[i + 1]
            i += 2
        elif args[i] == '--no-dry-run':
            dry_run = False
            i += 1
        else:
            i += 1
    
    downloader = ToutEnFrancaisDownloader()
    
    # Check if aria2c is available
    if not downloader.check_aria2c():
        return
    
    # Login if credentials provided
    if not downloader.login(email, password):
        print("Continuing without login...")
    
    print("🔍 Searching for content pages...")
    pages = downloader.find_content_pages()
    print(f"📄 Found {len(pages)} potential content pages")
    
    # Extract video URLs from all pages
    all_urls = []
    for page in pages:
        print(f"🔍 Checking: {page}")
        urls = downloader.extract_video_urls(page)
        all_urls.extend(urls)
        time.sleep(0.5)  # Be respectful
    
    # Remove duplicates and filter valid URLs
    unique_urls = []
    for url in set(all_urls):
        if urlparse(url).scheme in ['http', 'https']:
            unique_urls.append(url)
    
    print(f"🎯 Found {len(unique_urls)} unique download URLs")
    
    if unique_urls:
        downloader.download_with_aria2c(unique_urls, dry_run)
    else:
        print("❌ No downloadable content found. You may need to:")
        print("   1. Provide login credentials if the content requires authentication")
        print("   2. Check if the website structure has changed")
        print("   3. Verify the target URL is correct")

if __name__ == "__main__":
    main()