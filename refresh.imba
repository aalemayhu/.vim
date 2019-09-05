const path = require 'path'
const fs = require 'fs'

def decode str
  str.toString('utf-8')

if process:argv:length < 3
  console.log 'Missing path to submodules directory'
  process.exit 1

const root = process:argv[2]
const repos = fs.readdirSync(root)

if repos:length === 0
  console.log 'Submodules directory is empty'
  process.exit 1


for dir in repos
  console.log "[submodule \"{root}/{dir}\"]"
  let p = path.join(root, dir, '.git', 'config')
  const config = path.resolve(p)
  const data = decode(fs.readFileSync(config))
  for line in data.split('\n')
    if line.includes('url =')
      const url = line.trim().split('=')[1]
      console.log("        path = {root}/{dir}")
      console.log("        url = {url}")
