const express = require("express");
const router = express.Router();
const middleware = require('./middleware');
const Profile = require('./profilemodel');

router.route("/add").post(middleware.checkToken, (req, res) => {
    const profile = Profile({
      username: req.decoded.username,
      name: req.body.name,
      profession: req.body.profession,
      DOB: req.body.DOB,
      titleline: req.body.titleline,
      about: req.body.about,
    });
    profile
      .save()
      .then(() => {
        return res.send({ msg: "profile successfully stored" });
      })
      .catch((err) => {
        return res.status(400).json({ err: err });
      });
  });

  module.exports = router;