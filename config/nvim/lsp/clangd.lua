-- https://www.reddit.com/r/neovim/comments/12qbcua/multiple_different_client_offset_encodings/
return {
  -- arduino works if arduino-cli compile .. --build-path build
  filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'cuda', 'proto', 'arduino' },
  cmd = {
    "clangd",
    "--offset-encoding=utf-16",
  },
}
