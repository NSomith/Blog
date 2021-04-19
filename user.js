const express = require('express');
const User = require('./model');
const middleware = require('./middleware');

const config = require('./config');
const jwt = require('jsonwebtoken');

const router = express.Router();

router.post("/register", async (req, res) => {
    try {
        const newuser = new User({
            username: req.body.username,
            password: req.body.password,
            email: req.body.email
        });
        const user = await newuser.save();
        res.status(200).send(user);
    } catch (err) {
        res.status(400).send(err);
    }
});

router.patch("/update/:uname", async (req, res) => {
    try {
        const usertoFind = req.params.uname;
        const user = await User.findOneAndUpdate({
            username: usertoFind
        }, req.body, { new: true });
        const msg = {
            mess: "Updated",
            usernam: req.body.username
        }
        res.status(200).send(msg);
    } catch (err) {
        res.status(400).send(err);
    }
});

router.delete("/delete/:uname", async (req, res) => {
    try {
        const usertoDel = req.params.uname;
        const user = await User.findOneAndDelete({
            username: usertoDel
        });
        // const msg = {
        //     mess:"Deleted",
        //     usernam:usertoDel
        // }
        res.status(200).send(user);
    } catch (err) {
        res.status(400).send(err);
    }
});

router.get("/:uname", middleware.checkToken,(req, res) => {
    // var token = req.headers['Authorization'];
    // console.log(token);
    let serachname = req.params.uname;
    User.findOne({ username: serachname}, (err, result) => {
        if (err) res.status(400).send(err);
        res.send({
            data: result,
            username: serachname
        });
    })
});

router.post("/login", async (req, res) => {
    let loginuser = req.body.username;
    await User.findOne({ username: loginuser }, (err, result) => {
        if (err) res.status(400).send(err);
        if (result == null) {
            return res.status(400).send("no user present");
        }
        if (result.password == req.body.password) {
            //          use JWT token 
           let token = jwt.sign({ username: loginuser }, config.key, {
                expiresIn: "24h" //expire in }
            })
            res.json({
                token:token, //for the front end dev
                msg:"Succes"
            });
        } else {
            res.status(403).send("password is incorrect");
        }
    })
});

module.exports = router;