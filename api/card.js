var og = require('open-graph');
module.exports = (req, res) => {
  const { url = "" } = req.query
  console.log(url)
  og(url, function(err, meta) {
    res.setHeader('content-type', 'application/json');
    res.send(meta)
  })
}
