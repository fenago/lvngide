const pngToIco = require('png-to-ico');
const fs = require('fs');

pngToIco([
  'codesphere-logo-16.png',
  'codesphere-logo-32.png',
  'codesphere-logo-48.png'
])
  .then(buf => {
    fs.writeFileSync('favicon.ico', buf);
    console.log('favicon.ico created successfully');
  })
  .catch(console.error);
