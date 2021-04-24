const express = require('express');
const app = express();
const mongoose = require('mongoose');
app.use(express.json());
// const User = require('./model');
const port = process.env.PORT || 8000;

mongoose.connect("mongodb+srv://Somith:Somith16@@cluster1.3e5n9.mongodb.net/flutter?ssl=true&retryWrites=true&w=majority",
    {useNewUrlParser: true, useUnifiedTopology: true }
).then(() => { console.log("connection succesful") }).catch((err) => { console.log(err) });


// middleware
const userRoute = require('./user');
const profileRoute = require('./profile');
const { static } = require('express');
console.log(`the value of ${userRoute}`);
app.use("/user",userRoute,(req,res)=>{
    console.log("hi ji");
    res.send("hellow form router");
});


app.use("/uploads",express.static("uploads"));
app.use("/profile",profileRoute);

const blogRoute = require("./blogpost");
app.use("/blogpost", blogRoute);


app.get("/",(req,res)=>{
    res.json({
        msg: "Welcome",
        info: null,
    });
});

app.listen(port,()=>{console.log("listenting");});