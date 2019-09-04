#!/usr/bin/env deno run --allow-read
// deno generate gitmodules file
async function main() {
    if (Deno.args.length < 2) {
      console.log('Missing path to submodules directory')
      Deno.exit(1);
    }
    
    const modulesDirectory = Deno.args[1];
    const repos = await Deno.readDir(modulesDirectory);

    if (repos.length === 0) {
        console.log('Submodules directory is empty.');
        Deno.exit(1);
    }

    const decoder = new TextDecoder("utf-8");
    for (const dir of repos.map(f => f.path)) {
        console.log(`[submodule "${dir}"]`);
        const config = await Deno.readFile(`${dir}/.git/config`);
        const data = decoder.decode(config);

        for (const line of data.split('\n')) {
            if (line.includes('url =')) {
                console.log(`        path = ${dir}`)
                console.log(`        url = ${line.trim().split('=')[1]}`)
            }
        }
    }
}

main()
