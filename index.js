const express = require('express');
const app = express();
const mongoose = require('mongoose');
app.use(express.json());
// const User = require('./model');

mongoose.connect("mongodb+srv://Somith:Somith16@@cluster1.3e5n9.mongodb.net/flutter?retryWrites=true&w=majority",
    {useNewUrlParser: true, useUnifiedTopology: true }
).then(() => { console.log("connection succesful") }).catch((err) => { console.log(err) });


// middleware
const userRoute = require('./user');
console.log(`the value of ${userRoute}`);
app.use("/user",userRoute,(req,res)=>{
    console.log("hi ji");
    res.send("hellow form router");
});

app.get("/",(req,res)=>{
    res.send("gefd");
});

app.listen(8000,()=>{console.log("listenting");});