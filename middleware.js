const jwt = require('jsonwebtoken');
const config = require('./config');

let checkToken=(req,res,next)=>{
    let token = req.headers['authorization']; //create an authorization in the postamn auth with the token 
    console.log(`this is the ${token}`);
    token = token.slice(7,token.length);
    console.log(token);
    if (token) {
      jwt.verify(token, config.key, (err, decoded) => {
        if (err) {
          return res.send({
            status: false,
            msg: "token is invalid",
          });
        } else {
          req.decoded = decoded;
          next();
        }
      });
    } else {
      return res.send({
        status: false,
        msg: "Token is not provided",
      });
    }
    
    // next(); when we put this make an error 
}

module.exports = { checkToken: checkToken,};