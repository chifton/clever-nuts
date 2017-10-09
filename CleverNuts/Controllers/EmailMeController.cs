using CleverNuts.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Net.Mail;
using System.Web.Mvc;
using System.Net;
using Recaptcha;

namespace CleverNuts.Controllers
{
    public class EmailMeController : ApplicationRealController
    {
        //
        // GET: /EmailMe/
        [AllowAnonymous]
        public ActionResult Index(string returnUrl)
        {
            ViewBag.ReturnUrl = returnUrl;
            return View();
        }


        [HttpPost, RecaptchaControlMvc.CaptchaValidator]
        [AllowAnonymous]
        [ValidateAntiForgeryToken]
        public ActionResult Index(EmailModel emailModel, bool captchaValid, string captchaErrorMessage)
        {
            if (!captchaValid)
            {
                ModelState.AddModelError("captcha", captchaErrorMessage);
            }

            if (ModelState.IsValid)
            {
                bool isOk = false;
                try
                {
                    MailMessage msg = new MailMessage();
                    msg.From = new MailAddress("clevernuts88@gmail.com", "Website Contact Form");
                    msg.To.Add(new MailAddress("clevernuts88@gmail.com", "Chift"));
                    msg.Subject = emailModel.Subject;

                    string body = "Bonjour / Bonsoir Chift,\n" + "Ce message a été envoyé :\n\n"
                                + "Pseudo: " + emailModel.Name + "\n\n"
                                + "Email: " + emailModel.EmailAddress + "\n\n"
                                + emailModel.Message + "\n\n\n"
                                + "Reponds vite manitou Chift !";

                    msg.Body = body;
                    msg.IsBodyHtml = false;

                    using (var smtp = new SmtpClient("smtp.gmail.com", 587))
                    {
                        smtp.Credentials = new NetworkCredential("clevernuts88@gmail.com", "orxcaviytpcycxiq");
                        smtp.EnableSsl = true; // Si le serveur le permet sur le port correspondant, on peut activer le SSL

                        smtp.Send(msg);
                    }

                    msg.Dispose();

                    isOk = true;

                    MessageModel rcpt = new MessageModel();
                    rcpt.Title = "Thank You";
                    rcpt.Content = "Your email has been sent.";
                    return View("Message", rcpt);
                }
                catch (Exception ex)
                {
                }

                // If we are here...something kicked us into the exception.
                //
                MessageModel err = new MessageModel();
                err.Title = "Email Error";
                err.Content = "The website is having an issue with sending email at this time. Sorry for the inconvenience.";
                return View("Message", err);
            }
            else
            {
                return View();
            }
        }
    }
}