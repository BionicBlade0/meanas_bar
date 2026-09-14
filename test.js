var http = require('https')
http.get("https://wallhaven.cc/", { header: { "Host": "th.wallhaven.cc", "User-Agent": "Mozilla/5.0 (X11; Linux x86_64; rv:149.0) Gecko/20100101 Firefox/149.0" } }, (req) => {

    let data = []
    req.on('data', (chunk) => {
        data += chunk
    })

    req.on('end', () => {
        const re = /https:\/\/wallhaven.cc\/w\/[a-z0-9]+/g
        const matches = data.match(re)

        for (image_page of matches) {
            http.get("https://wallhaven.cc/", { header: { "Host": "th.wallhaven.cc", "User-Agent": "Mozilla/5.0 (X11; Linux x86_64; rv:149.0) Gecko/20100101 Firefox/149.0" } }, (req) => {
                let data2 = []
                req.on('data', (chunk) => {
                    data2 += chunk
                })

                req.on('end', () => {
                    const re2 = /https:\/\/w.wallhaven.cc\/full\/[a-z0-9]\.jpg/g
                    const matches2 = data2.match(re2)
                    console.log(matches2)
                })
            })
        }

        // console.log(matches)
    })

})


console.log("Hello World")