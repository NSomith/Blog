const express = require('express');
const router = express.Router();
const BlogPost = require('./blogpostModel');
const middleware = require('./middleware');
const multer = require("multer");

const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, "./uploads");
  },
  filename: (req, file, cb) => {
    cb(null, req.params.id + ".jpg");
  },
});

const upload = multer({
  storage: storage,
  limits: {
    fileSize: 1024 * 1024 * 6,
  },
});

router.patch("/add/coverimage/:id", middleware.checkToken, upload.single("img"), async (req, res) => {
  await BlogPost.findOneAndUpdate(
    { _id: req.params.id },
    {
      $set: {
        coverImage: req.file.path,
      },
    }, { new: true, useFindAndModify: true },
    (err, blog) => {
      if (err) return res.status(500).send(err);
      const response = {
        message: "image added successfully updated",
        data: blog,
      };
      return res.status(200).send(response);
    }
  );
});

router.get('/getOwnBlog',middleware.checkToken,async(req,res)=>{
  await BlogPost.find({username:req.decoded.username},(err,result)=>{
    if(err) return res.send(err);
    return res.send({data:result});
  });
});

router.get('/getOtherBlog',middleware.checkToken,async(req,res)=>{
  await BlogPost.find({username:{$ne:req.decoded.username}},(err,result)=>{
    if(err) return res.send(err);
    return res.send({data:result});
  });
});

router.route("/delete/:id").delete(middleware.checkToken, (req, res) => {
  BlogPost.findOneAndDelete(
    {
      $and: [{ username: req.decoded.username }, { _id: req.params.id }],
    },
    (err, result) => {
      if (err) return res.json(err);
      else if (result) {
        console.log(result);
        return res.json("Blog deleted");
      }
      return res.json("Blog not deleted");
    }
  );
});



router.route("/add").post(middleware.checkToken, (req, res) => {
  const blogpost = BlogPost({
    username: req.decoded.username,
    title: req.body.title,
    body: req.body.body,
  });
  blogpost
    .save()
    .then((result) => {
      res.json({ data: result["_id"] });
    })
    .catch((err) => {
      console.log(err), res.json({ err: err });
    });
});

module.exports = router;
