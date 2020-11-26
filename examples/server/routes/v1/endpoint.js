const { Router } = require('express');
const router = Router();

router.get('/path', (req, res) => {
    res.send('success')
})

module.exports = router;