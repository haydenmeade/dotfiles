local M = {}

function M.config()
  return {
    settings = {
      yaml = {
        format = {
          enable = true,
        },
        hover = true,
        completion = true,
        customTags = {
          "!fn",
          "!And",
          "!If",
          "!Not",
          "!Equals",
          "!Or",
          "!FindInMap sequence",
          "!Base64",
          "!Cidr",
          "!Ref",
          "!Ref Scalar",
          "!Sub",
          "!GetAtt",
          "!GetAZs",
          "!ImportValue",
          "!Select",
          "!Split",
          "!Join sequence",
        },
      },
    },
  }
end

return M
