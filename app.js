const express = require('express');
const app = express();
const port = process.env.PORT || 8080;

app.get('/', (req, res) => {
    res.send('Hello, this is an UPDATED version from OpenShift CI/CD Pipeline!and sprint plannig with Mr VP, TT and TK');
});

app.listen(port, () => {
    console.log(`App listening on port ${port}`);
});
