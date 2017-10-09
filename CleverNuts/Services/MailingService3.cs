using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Mail;
using System.Net.Mime;
using System.Text;
using System.Web;

namespace CleverNuts.Services
{
    public class MailingService3
    {
        // Vous pouvez mettre ce que vous voulez ici.
        private const string SenderEmail = "clevernuts88@gmail.com";
        private const string SenderName = "Clever Nuts";
        private string path = HttpContext.Current.Server.MapPath("~/Images/affiche2.png");

        // L'url de base de votre site web.
        private const string SitewebUrl = "https://www.clevernuts.org/";

        // Ces informations-ci doivent être correctes pour pouvoir envoyer un email!
        private const string SmtpServerUrl = "smtp.gmail.com";
        private const int SmtpServerPort = 587;
        private const string SmtpServerUsername = "clevernuts88@gmail.com";
        private const string SmtpServerPassword = "noqgbqfxbtmfeojs";

        public void SendTokenByEmail(string token, string recipient, string username)
        {
            var message = new MailMessage();
            message.From = new MailAddress(SenderEmail, SenderName);
            message.To.Add(new MailAddress(recipient, username));


            message.Subject = "Clever Nuts / Welcome !";

            const string template = @"<html>
                                    <body>
                                     <h2>Welcome on Clever Nuts !</h2>
                                     <p>You are now a nutter !</p>
                                     <p>You can play awale or buy nuts to save squirrels and recover the village !</p>
                                     <p>Enjoy !</p>
                                     <p>Chift</p>
                                    </body>
                                   </html>";


            var url = String.Format("{0}account/resetpassword/?token={1}", SitewebUrl, token);

            var alternativeView = AlternateView.CreateAlternateViewFromString(
                string.Format(template, url),
                Encoding.UTF8,
                MediaTypeNames.Text.Html);

            LinkedResource logo2 = new LinkedResource(path);
            logo2.ContentId = "companylogo";
            // alternativeView.LinkedResources.Add(logo2);
            message.AlternateViews.Add(alternativeView);

            using (var smtpClient = new SmtpClient(SmtpServerUrl, SmtpServerPort))
            {
                smtpClient.Credentials = new NetworkCredential(SmtpServerUsername, SmtpServerPassword);
                smtpClient.EnableSsl = true; // Si le serveur le permet sur le port correspondant, on peut activer le SSL

                smtpClient.Send(message);
            }
        }
    }
}