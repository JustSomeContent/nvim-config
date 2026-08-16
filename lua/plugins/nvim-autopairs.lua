-- Automatically add matching pairs of chars
return {
  'windwp/nvim-autopairs',
  event = "InsertEnter",
  config = true,
  opts = {}
  -- use opts = {} for passing setup options
  -- this is equivalent to setup({}) function
}
