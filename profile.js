const express = require("express");
const router = express.Router();
const middleware = require('./middleware');
const Profile = require('./profilemodel');
const multer = require('multer');
// const path = require('path');

const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, "./uploads");
  },
  filename: (req, file, cb) => {
    cb(null, req.decoded.username + ".jpg");
  },
});

const fileFilter = (req, file, cb) => {
  if (file.mimetype == "image/jpeg" || file.mimetype == "image/png") {
    cb(null, true);
  } else {
    cb(null, false);
  }
};

const upload = multer({
  storage: storage,
  limits: {
    fileSize: 1024 * 1024 * 6,
  },
  // fileFilter: fileFilter,
});
//adding and update profile image
router.patch("/add/image", middleware.checkToken, upload.single("img"), async (req, res) => {
  console.log(req.file);
  await Profile.findOneAndUpdate(
    { username: req.decoded.username },
    {
      $set: {
        img: req.file.path,
      },
    },
    { new: true, useFindAndModify: true },
    (err, profile) => {
      if (err) return res.status(500).send(err);
      const response = {
        message: "image added successfully updated",
        data: profile,
      };
      return res.status(200).send(response);
    }
  );
});

router.get("/getdata", middleware.checkToken, async (req, res) => {
  await Profile.findOne(
    { username: req.decoded.username },
    (err, response) => {
      if (err) return res.status(500).send(err);
      if (response == null) {
        return res.send({ data: [] });
      } else {
        return res.send({ data: response });
      }
    }
  );
});

// update single thing like name,about stuff section
router.patch("/update", middleware.checkToken, async (req, res) => {
  let profile = {};
  await Profile.findOne(
    { username: req.decoded.username },
    (err, response) => {
      if (err) {
        profile = {};
      }
      if (response != null) {
        profile = response;
      }
    }
  );
  await Profile.findOneAndUpdate(
    { username: req.decoded.username },
    {
      $set: {
        name: req.body.name ? req.body.name : profile.name,
        profession: req.body.profession ? req.body.profession : profile.profession,
        DOB: req.body.DOB ? req.body.DOB : profile.DOB,
        titleline: req.body.titleline ? req.body.titleline : profile.titleline,
        about: req.body.about ? req.body.about : profile.about,

      },
    },
    { new: true, useFindAndModify: true },
    (err, response) => {
      if (err) return res.status(500).send(err);
      if (response == null) {
        return res.send({ data: [] });
      } else {
        return res.send({ data: response });
      }
    }
  );
});


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

router.get("/checkProfile", middleware.checkToken, async (req, res) => {
  await Profile.findOne({
    username: req.decoded.username
  }, (err, result) => {
    if (err) {
      return res.send(err);
    } else {
      if (result == null) {
        return res.send({ status: false });
      } else {
        return res.send({ status: true });
      }
    }
  });
});

module.exports = router;