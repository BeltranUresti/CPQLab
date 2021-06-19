/*!
 * Creative v1.0.4 (http://startbootstrap.com/template-overviews/creative)
 * Copyright 2013-2016 Start Bootstrap
 * Licensed under MIT (https://github.com/BlackrockDigital/startbootstrap/blob/gh-pages/LICENSE)
 */
@import url('https://fonts.googleapis.com/css?family=Montserrat');

html,
body {
  height: 100%;
  width: 100%;
  overflow-y: hidden;
}
body {
  font-family: 'Montserrat', sans-serif; /*'Merriweather', 'Helvetica Neue', Arial, sans-serif;*/
}
hr {
  border-color: #00bf71;
  border-width: 3px;
  max-width: 50px;
}
hr.light {
  border-color: white;
}
a.nav-links{
  -webkit-transition: all 0.35s;
  -moz-transition: all 0.35s;
  transition: all 0.35s;
  color: #ffffff;
}
a.nav-links:hover,
a.nav-links:focus{
  color: #008f55;
  text-decoration: none;
}

a.footer-links{
  -webkit-transition: all 0.35s;
  -moz-transition: all 0.35s;
  transition: all 0.35s;
  color: #00bf71;
}
a.footer-links:hover,
a.footer-links:focus{
  color: #008f55;
  text-decoration: none;
}

h1,
h2,
h3,
h4,
h5,
h6 {
  font-family: 'Montserrat', sans-serif; /*'Open Sans', 'Helvetica Neue', Arial, sans-serif;*/
}
p {
  font-size: 16px;
  line-height: 1.5;
  margin-bottom: 20px;
}
footer {
    padding: 15px;
    background-color: #fff;
    color: #222;
}
.bg-primary {
  background-color: #00bf71;
}
.bg-dark {
  background-color: #222222;
  color: white;
}
.text-faded {
  color: rgba(255, 255, 255, 0.7);
}
.footer {
    position: absolute;
    color: white;
    width: 100%;
    height: 30px;
    background-color: #b3b3b3;
    text-align: center;
}
section {
  padding: 30px 0;
}
aside {
  padding: 50px 0;
}
#overlays {
    background-color: rgba(0,0,0,0.3);
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
}
.no-padding {
  padding: 0;
}
.navbar-default {
  background-color: white;
  border-color: rgba(34, 34, 34, 0.05);
  font-family: 'Montserrat', sans-serif; /*'Merriweather', 'Helvetica Neue', Arial, sans-serif;*/
  -webkit-transition: all 0.35s;
  -moz-transition: all 0.35s;
  transition: all 0.35s;
}
.navbar-default .navbar-header .navbar-brand {
  color: #00bf71;
  font-family: 'Montserrat', sans-serif; /*'Merriweather', 'Helvetica Neue', Arial, sans-serif;*/
  font-weight: 700;
  text-transform: uppercase;
  padding-top: 0px;
}
.navbar-default .navbar-header .navbar-brand:hover,
.navbar-default .navbar-header .navbar-brand:focus {
  color: #eb3812;
}
.navbar-default .nav > li > a,
.navbar-default .nav > li > a:focus {
  text-transform: uppercase;
  font-weight: 700;
  font-size: 13px;
  color: #222222;
}
.navbar-default .nav > li > a:hover,
.navbar-default .nav > li > a:focus:hover {
  color: #00bf71;
}
.navbar-default .nav > li.active > a,
.navbar-default .nav > li.active > a:focus {
  color: #00bf71 !important;
  background-color: transparent;
}
.navbar-default .nav > li.active > a:hover,
.navbar-default .nav > li.active > a:focus:hover {
  background-color: transparent;
}
header {
  position: relative;
  width: 100%;
  min-height: 100%;
  -webkit-background-size: cover;
  -moz-background-size: cover;
  background-size: cover;
  -o-background-size: cover;
  background-position: center;
  /*background-image: url('../img/header.jpg');*/
  background-image: url('../img/landing_bg.png');
  text-align: center;
  color: white;
}
header .header-content {
  position: relative;
  text-align: center;
  padding: 10px 15px;
  width: 100%;
}

header .header-content .header-content-inner h1 {
  font-size: 65px;
  font-weight: 700;
  text-transform: uppercase;
  margin-top: 0;
  margin-bottom: 0;
  text-shadow: 4px 4px 2px rgba(0, 0, 0, 1);
}

header .header-content .header-content-inner .header-box h1 {
  font-size: 14px !important;
  color: #b0b0b0;
  font-weight: 700;
  text-transform: none;
  text-shadow: none;
  margin: auto;
  margin-bottom: 25px;
  width: 50%;
  line-height: 1.6;
}

header .header-content .header-content-inner h2 {
  font-size: 45px;
  font-weight: 500;
  margin-top: 0;
  margin-bottom: 0;
  text-shadow: 4px 4px 2px rgba(0, 0, 0, 1);
}
header .header-content .header-content-inner hr {
  margin: 30px auto;
}
header .header-content .header-content-inner p {
  font-weight: 300;
  color: rgba(255, 255, 255, 0.7);
  font-size: 16px;
  margin-bottom: 50px;
}

.modal-body {
    /*max-height: calc(100vh - 210px);*/
    /*max-height: 100vh;*/
    overflow-y: auto;
    width: 50%;
    margin: auto;
}

.modal-body p{
    font-size: 14px;
}

#email-body{
  resize: none;
  min-height: 75px;
}

.icon {
  width: 18px;
  height: 18px;
  cursor: pointer;
  /*filter: invert(74%) sepia(57%) saturate(5387%) hue-rotate(114deg) brightness(90%) contrast(101%);*/
}

.icon-container{
  display: block;
  cursor: pointer
}

.icon-white {
  width: 18px;
  height: 18px;
  /*filter: invert(100%) sepia(0%) saturate(0%) hue-rotate(51deg) brightness(102%) contrast(101%);*/
  margin-right: 10px;
  margin-top: -3px;
}

.icon-nav {
  width: 18px;
  height: 18px;
  float:right;
  cursor:pointer;
  margin-top: 18px;
  margin-right: 20px;
  /*filter: invert(1);*/
}

.modal{
  padding-right: 0 !important;
}

#myModal{
  overflow-y:auto !important;
}

.btn-add-questions-form{
  pointer-events: none;
}

.btn-add-signer{
  cursor: pointer;
}

.centered{
  position: absolute;
  left: 50%;
  top: 50%;
  -webkit-transform: translate(-50%, -50%);
  transform: translate(-50%, -50%);
}

.modal-dialog {
  width: 100%;
  max-width: 100%;
  height: 100%;
  margin: 0;
  padding: 0;
}

.modal-dialogv2 {
  width: 600px;
  margin: auto;
  position: relative;
  -webkit-animation: mymove 0.5s; /* Safari 4.0 - 8.0 */
  animation: mymove 0.5s;
}

.modal-dialogv2 {-webkit-animation-timing-function: ease-out;}
.modal-dialogv2 {animation-timing-function: ease-out;}

/* Safari 4.0 - 8.0 */
@-webkit-keyframes mymove {
  from {top: -250px;}
  to {top: 0px;}
}

/* Standard syntax */
@keyframes mymove {
  from {top: -250px;}
  to {top: 0px;}
}

.modal-content {
  height: auto;
  min-height: 100%;
  border-radius: 0;
}

.modal-contentv2{
  background-color: #000000;
  color: #FFFFFF;
  opacity: 0.90;
  height: auto;
  min-height: 100%;
}

#login-logo{
  display: block;
  max-width: 100%;
  height: auto;
  /*margin: auto; para tener el logo centrado*/
  width: 15%;
}

#logo-container{
  width: 50%;
}

#languages-container{
  width: 50%;
}

@media (min-width: 768px) {
  .navbar-default {
    background-color: transparent;
    border-color: rgba(255, 255, 255, 0.3);
  }
  .navbar-default .navbar-header .navbar-brand {
    color: rgba(255, 255, 255, 0.7);
  }
  .navbar-default .navbar-header .navbar-brand:hover,
  .navbar-default .navbar-header .navbar-brand:focus {
    color: white;
  }
  .navbar-default .nav > li > a,
  .navbar-default .nav > li > a:focus {
    color: rgba(255, 255, 255, 0.7);
  }
  .navbar-default .nav > li > a:hover,
  .navbar-default .nav > li > a:focus:hover {
    color: white;
  }
  .navbar-default.affix {
    background-color: white;
    border-color: rgba(34, 34, 34, 0.05);
  }
  .navbar-default.affix .navbar-header .navbar-brand {
    color: #00bf71;
    font-size: 14px;
  }
  .navbar-default.affix .navbar-header .navbar-brand:hover,
  .navbar-default.affix .navbar-header .navbar-brand:focus {
    color: #eb3812;
  }
  .navbar-default.affix .nav > li > a,
  .navbar-default.affix .nav > li > a:focus {
    color: #222222;
  }
  .navbar-default.affix .nav > li > a:hover,
  .navbar-default.affix .nav > li > a:focus:hover {
    color: #00bf71;
  }
  .carousel-indicators {
    bottom: -10px;
  }
  .carousel-caption {
    position: static;
    right: 15%;
    bottom: 20px;
    left: 15%;
    z-index: 10;
    padding-top: 20px;
    padding-bottom: 30px;
    color: #fff;
    text-align: center;
    text-shadow: 0 1px 2px rgba(0,0,0,.6);
    width: 75%;
    margin-left: auto;
    margin-right: auto;
  }
  #landing_logo{
    margin-right: auto;
    width: 20%;
  }
  #login-logo {
    width: 10%;
  }
}

@media (max-width: 768px) {
  .navbar-brand {
    height: 0px;
    padding: 10px 10px;
  }
  #login-logo{
    width: 25%;
  }
  header .header-content .header-content-inner h1 {
  font-size: 35px;
  }
  header .header-content .header-content-inner h2 {
    font-size: 25px;
  }
  header .header-content .header-content-inner .header-box {
    width: 100%;
    height: 350px;
    padding: 15px;
    background-color: #fff;
    box-shadow: -5px 5px #00bf71;
    border-radius: 5px;
  }
  .carousel-indicators {
    bottom: -10px;
  }
  .carousel-caption {
    position: initial;
    right: 15%;
    bottom: 20px;
    left: 15%;
    z-index: 10;
    padding-top: 20px;
    padding-bottom: 30px;
    color: #fff;
    text-align: center;
    text-shadow: 0 1px 2px rgba(0,0,0,.6);
    width: 75%;
    margin-left: auto;
    margin-right: auto;
  }
  #landing_logo {
    width: 50%;
  }
}

@media (max-width: 480px) {
  #img-captcha {
    width: 100%;
    margin-bottom: 10px;
  }
  #captcha-value{
    width: 70% !important;
    margin-top: 7px;
  }
  .modal-footer {
    padding: 15px 0 15px 0;
    text-align: center;
  }
  .modal-body {
    width: 100%;
  }
  #login-logo{
    width: 50%;
  }
  /*.modal-content {
    margin-right: 0% !important;
    padding: 5px 5px !important;
  }
  .modal-dialog {
    margin: 0;
    position: relative;
    top: 50%;
    transform: translateY(-50%) !important;
  }*/

  .modal-dialogv2 {
    width: auto;
  }

  #document-list {
    width: 100% !important;
  }
  #validatedLogoDownload{
    float: left;
  }
}

@media (min-width: 1024px) {
  .modal-body {
    width: 50%;
  }
  #login-logo{
    width: 15%;
  }
}
@media (min-width: 768px) {
  header {
    min-height: 100%;
  }
  header .header-content {
    position: absolute;
    /*top: 50%;
    -webkit-transform: translateY(-50%);
    -ms-transform: translateY(-50%);
    transform: translateY(-50%);
    padding: 0 50px;*/
  }
  header .header-content .header-content-inner {
    /*
    max-width: 600px;

    margin-left: auto;

    margin-right: auto;
    */
    margin-left: 15%;
    margin-top: 200px;
    float: left;
  }

  header .header-content .header-content-inner .header-box {
    width: 400px;
    height: 350px;
    padding: 15px;
    background-color: #fff;
    box-shadow: -5px 5px #008f55;
    border-radius: 5px;
  }

  header .header-content .header-content-inner p {
    font-size: 18px;
    max-width: 80%;
    margin-left: auto;
    margin-right: auto;
  }
}

@media (max-height: 700px) and (min-width: 768px){
  header .header-content .header-content-inner .header-box {
    width: 55%;
    height: 350px;
    padding: 15px;
    background-color: #fff;
    box-shadow: -5px 5px #00bf71;
    border-radius: 5px;
    margin: auto;
  }
  header .header-content .header-content-inner {
    margin-left: initial;
    margin-top: initial;
    float: initial;
  }
  .btn-download{
    width: 50% !important;
    display: initial !important;
    min-width: 260px;
    font-size: 10px !important;
  }
  #logo-container{
    width: 45%;
  }
  #languages-container{
    width: 55%;
  }
}

.section-heading {
  margin-top: 0;
}
.service-box {
  max-width: 400px;
  margin: 50px auto 0;
}
@media (min-width: 992px) {
  .service-box {
    margin: 20px auto 0;
  }
}
.service-box p {
  margin-bottom: 0;
}
.portfolio-box {
  position: relative;
  display: block;
  max-width: 650px;
  margin: 0 auto;
}
.portfolio-box .portfolio-box-caption {
  color: white;
  opacity: 0;
  display: block;
  background: rgba(240, 95, 64, 0.9);
  position: absolute;
  bottom: 0;
  text-align: center;
  width: 100%;
  height: 100%;
  -webkit-transition: all 0.35s;
  -moz-transition: all 0.35s;
  transition: all 0.35s;
}
.portfolio-box .portfolio-box-caption .portfolio-box-caption-content {
  width: 100%;
  text-align: center;
  position: absolute;
  top: 50%;
  transform: translateY(-50%);
}
.portfolio-box .portfolio-box-caption .portfolio-box-caption-content .project-category,
.portfolio-box .portfolio-box-caption .portfolio-box-caption-content .project-name {
  font-family: 'Montserrat', sans-serif; /*'Merriweather', 'Helvetica Neue', Arial, sans-serif;*/
  padding: 0 15px;
}
.portfolio-box .portfolio-box-caption .portfolio-box-caption-content .project-category {
  text-transform: uppercase;
  font-weight: 600;
  font-size: 14px;
}
.portfolio-box .portfolio-box-caption .portfolio-box-caption-content .project-name {
  font-size: 18px;
}
.portfolio-box:hover .portfolio-box-caption {
  opacity: 1;
}
.portfolio-box:focus {
  outline: none;
}
@media (min-width: 768px) {
  .portfolio-box .portfolio-box-caption .portfolio-box-caption-content .project-category {
    font-size: 16px;
  }
  .portfolio-box .portfolio-box-caption .portfolio-box-caption-content .project-name {
    font-size: 22px;
  }
}

.call-to-action h2 {
  margin: 0 auto 20px;
}
.text-primary {
  color: #00bf71;
}
.no-gutter > [class*='col-'] {
  padding-right: 0;
  padding-left: 0;
}
.btn-default {
  color: #222222;
  background-color: #ffffff;
  border-color: #ffffff;
  -webkit-transition: all 0.35s;
  -moz-transition: all 0.35s;
  transition: all 0.35s;
}
.btn-default:hover,
.btn-default:focus,
.btn-default.focus,
.btn-default:active,
.btn-default.active,
.open > .dropdown-toggle.btn-default {
  color: #222222;
  background-color: #f2f2f2;
  border-color: #ededed;
}
.btn-default:active,
.btn-default.active,
.open > .dropdown-toggle.btn-default {
  background-image: none;
}
.btn-default.disabled,
.btn-default[disabled],
fieldset[disabled] .btn-default,
.btn-default.disabled:hover,
.btn-default[disabled]:hover,
fieldset[disabled] .btn-default:hover,
.btn-default.disabled:focus,
.btn-default[disabled]:focus,
fieldset[disabled] .btn-default:focus,
.btn-default.disabled.focus,
.btn-default[disabled].focus,
fieldset[disabled] .btn-default.focus,
.btn-default.disabled:active,
.btn-default[disabled]:active,
fieldset[disabled] .btn-default:active,
.btn-default.disabled.active,
.btn-default[disabled].active,
fieldset[disabled] .btn-default.active {
  background-color: #ffffff;
  border-color: #ffffff;
}
.btn-default .badge {
  color: #ffffff;
  background-color: #222222;
}
.btn-primary {
  color: #ffffff;
  background-color: #00bf71;
  border-color: #00bf71;
  -webkit-transition: all 0.35s;
  -moz-transition: all 0.35s;
  transition: all 0.35s;
}
.btn-primary:hover,
.btn-primary:focus,
.btn-primary.focus,
.btn-primary:active{
  background-color: #008f55 !important;
  border-color: #008f55;
}
.btn-primary.active,
.open > .dropdown-toggle.btn-primary {
  color: #ffffff;
  background-color: #008f55;
  border-color: #008f55;
}
.btn-primary:active,
.btn-primary.active,
.open > .dropdown-toggle.btn-primary {
  background-image: none;
}
.btn-primary.disabled,
.btn-primary[disabled],
fieldset[disabled] .btn-primary,
.btn-primary.disabled:hover,
.btn-primary[disabled]:hover,
fieldset[disabled] .btn-primary:hover,
.btn-primary.disabled:focus,
.btn-primary[disabled]:focus,
fieldset[disabled] .btn-primary:focus,
.btn-primary.disabled.focus,
.btn-primary[disabled].focus,
fieldset[disabled] .btn-primary.focus,
.btn-primary.disabled:active,
.btn-primary[disabled]:active,
fieldset[disabled] .btn-primary:active,
.btn-primary.disabled.active,
.btn-primary[disabled].active,
fieldset[disabled] .btn-primary.active {
  background-color: #00bf71;
  border-color: #00bf71;
}
.btn-primary .badge {
  color: #00bf71;
  background-color: #ffffff;
}
.btn {
  font-family: 'Montserrat', sans-serif; /*'Merriweather', 'Helvetica Neue', Arial, sans-serif;*/
  /*border: none;*/
  border-radius: 5px;
  font-weight: 600;
  padding: 10px 5px;
  text-transform: uppercase;
  font-size: 12px;
}

.tooltip-container {
  position: relative;
  display: table;
  cursor: pointer;
}

.tooltip-container .tooltiptext {
  visibility: hidden;
  width: 120px;
  background-color: #555;
  color: #fff;
  text-align: center;
  border-radius: 6px;
  padding: 5px 0;
  position: absolute;
  z-index: 1;
  bottom: 125%;
  left: 50%;
  margin-left: -60px;
  opacity: 0;
  transition: opacity 0.3s;
}

.tooltip-container .tooltiptext::after {
  content: "";
  position: absolute;
  top: 100%;
  left: 50%;
  margin-left: -5px;
  border-width: 5px;
  border-style: solid;
  border-color: #555 transparent transparent transparent;
}

.tooltip-container:hover .tooltiptext {
  visibility: visible;
  opacity: 1;
}

#button-with-icon{
  display: inline-block;
  padding: 15px 10px 15px 10px;
  background-color: #00bf71;
  transition: background-color 0.35s ease-out;
  /* padding-top: 15px; */
  /* border: 1px solid #888b8d; */
  /* border-width: 3px; */
  border-radius: 5px;
  cursor: pointer;
}

#button-with-icon:hover {
  background-color: #008f55;
}

#button-with-icon-span{
  color: #aaadb3;
  font-weight: 600;
  /*text-transform: uppercase;*/
  font-family: 'Montserrat', sans-serif; /*'Merriweather', 'Helvetica Neue', Arial, sans-serif;*/
}

#button-with-icon-span2{
  color: #434446;
  font-weight: 600;
  /*text-transform: uppercase;*/
  font-family: 'Montserrat', sans-serif; /*'Merriweather', 'Helvetica Neue', Arial, sans-serif;*/
}

#btn-close{
  background-color: #f1f1f1 !important;
  border-color: #888B8D !important;
  color: #888B8D !important;
  min-width: 150px !important;
  transition: border-color 0.35s ease-out, color 0.35s ease-out;
}

#btn-close:hover{
  color: #434446 !important;
  border-color: #434446 !important;
}

.modal-footer{
  padding: 0 !important;
  border-top: none !important;
  text-align: center !important;
}

.modal-footerv2{
  padding: 15px;
}

#btn-return-signer{
  background-color: #f1f1f1 !important;
  border-color: #888B8D !important;
  color: #888B8D !important;
  min-width: 150px !important;
  transition: border-color 0.35s ease-out, color 0.35s ease-out;
}

#btn-return-signer:hover{
  color: #434446 !important;
  border-color: #434446 !important;
}

.btn-xl {
  padding: 15px 30px;
}
::-moz-selection {
  color: white;
  text-shadow: none;
  background: #222222;
}
::selection {
  color: white;
  text-shadow: none;
  background: #222222;
}
img::selection {
  color: white;
  background: transparent;
}
img::-moz-selection {
  color: white;
  background: transparent;
}
body {
  webkit-tap-highlight-color: #222222;
}

.modal-content {
  /*margin-right: 10%;*/
  /*padding: 15px 15px;*/
  text-align: center;
  /*background-color: rgba(1,65,101,0.8);*/
  /*background-color: rgba(0,192,113,0.8);*/
  /*background-color: rgba(255,255,255,1);*/
  background-color: #f1f1f1;
  /*-webkit-box-shadow: 10px 10px 10px 0px rgba(0,0,0,0.5);
  -moz-box-shadow: 10px 10px 10px 0px rgba(0,0,0,0.5);
  box-shadow: 10px 10px 10px 0px rgba(0,0,0,0.5);
  border-radius: 10px 10px 10px 10px;
  -moz-border-radius: 10px 10px 10px 10px;
  -webkit-border-radius: 10px 10px 10px 10px;
  border: 0px solid #000000;*/
}
#filedrag {
  background-color:#FFFFFF;
  height:215px;
  font-size: 1em;
  text-align: center;
  color: #434446;
  border: 2px solid #cfcfd1;
  border-radius: 7px;
  cursor: pointer;
  text-align:center;
}

#filedrag:hover {
  border-color: #9ea0a3;
  border-style: solid;
}

.select-file {
  font-weight: bold;
  color: #434446;
  cursor: pointer;
}

#div-send{
  width:100%;
  text-align:center;
}

#div-preview{
  width:100%;
  text-align:center;
}
#file-info{
  margin-top:20px;
  color: white;
}
#file-to-upload{
  display:none;
}
#img-captcha{
  border-radius: 5px;
}

#img-captcha-refresh{
  width:40px;
  margin-left:15px;
  vertical-align:top;
  margin-top:4px;
  cursor:pointer;
}
.logo-modal {
    position: absolute;
    height: 50px;
}
