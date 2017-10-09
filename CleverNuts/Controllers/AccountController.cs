using System;
using System.Collections.Generic;
using System.Linq;
using System.Transactions;
using System.Web;
using System.Web.Mvc;
using System.Web.Security;
using System.Diagnostics;
using DotNetOpenAuth.AspNet;
using Microsoft.Web.WebPages.OAuth;
using WebMatrix.WebData;
using CleverNuts.Filters;
using CleverNuts.Models;
using CleverNuts.Services;

namespace CleverNuts.Controllers
{
    [Authorize]
    [InitializeSimpleMembership]
    public class AccountController : ApplicationRealController
    {
        //
        // GET: /Account/Login

        [AllowAnonymous]
        public ActionResult Login(string returnUrl)
        {
            ViewBag.ReturnUrl = returnUrl;
            return View();
        }

        //
        // POST: /Account/Login

        [HttpPost]
        [AllowAnonymous]
        [ValidateAntiForgeryToken]
        public ActionResult Login(LoginModel model, string returnUrl)
        {
            if (ModelState.IsValid && WebSecurity.Login(model.UserName, model.Password, persistCookie: model.RememberMe))
            {
                // Pour compter le nombre de visiteurs
                OnlineActiveUsers.OnlineUsersInstance.OnlineUsers.SetUserOnline(model.UserName);
                // Pour s'ajouter à la liste des users on line en cache
                if (HttpRuntime.Cache["LoggedInUsers"] != null) //if the list exists, add this user to it
                {
                    //get the list of logged in users from the cache
                    List<string> loggedInUsers = (List<string>)HttpRuntime.Cache["LoggedInUsers"];
                    //add this user to the list
                    loggedInUsers.Add(model.UserName);
                    //add the list back into the cache
                    HttpRuntime.Cache["LoggedInUsers"] = loggedInUsers;
                }
                else //the list does not exist so create it
                {
                    //create a new list
                    List<string> loggedInUsers = new List<string>();
                    //add this user to the list
                    loggedInUsers.Add(model.UserName);
                    //add the list into the cache
                    HttpRuntime.Cache["LoggedInUsers"] = loggedInUsers;
                }

                return RedirectToLocal(returnUrl);
            }

            // Si nous sommes arrivés là, quelque chose a échoué, réafficher le formulaire
            ModelState.AddModelError("", "Incorrect username or password !");
            return View(model);
        }

        //
        // POST: /Account/LogOff

        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult LogOff()
        {
            WebSecurity.Logout();
            // Pour gérer le nombre de users online - le user actuel
            OnlineActiveUsers.OnlineUsersInstance.OnlineUsers.SetUserOffline(User.Identity.Name);
            // Enlève le user actuel de la liste des users en ligne
            string username = User.Identity.Name; //get the users username who is logged in
            if (HttpRuntime.Cache["LoggedInUsers"] != null)//check if the list has been created
            {
                //the list is not null so we retrieve it from the cache
                List<string> loggedInUsers = (List<string>)HttpRuntime.Cache["LoggedInUsers"];
                if (loggedInUsers.Contains(username))//if the user is in the list
                {
                    //then remove them
                    loggedInUsers.Remove(username);
                }
                // else do nothing
            }
            //else do nothing
            return RedirectToAction("Index", "Home");
        }

        //
        // GET: /Account/Register

        [AllowAnonymous]
        public ActionResult Register()
        {
            return View();
        }

        //
        // POST: /Account/Register

        [HttpPost]
        [AllowAnonymous]
        [ValidateAntiForgeryToken]
        public ActionResult Register(RegisterModel model)
        {
            if (ModelState.IsValid)
            {
                // Tentative d'inscription de l'utilisateur
                try
                {
                    // On crée le token de confirmation
                    string confirmationToken = WebSecurity.CreateUserAndAccount(model.UserName, model.Password, new { Email = model.Email, UserNuts1 = 30, UserNuts2 = 0, UserNuts3 = 0, UserBonus = 0, UserLevel = 1 }, true);
                    using (UsersContext context = new UsersContext())
                    {
                        UserProfile user = context.UserProfiles.FirstOrDefault(u => u.UserName == model.UserName);
                        user.Email = model.Email;
                        context.SaveChanges();
                    }
                    
                    // ... et on l'envoit à l'utilisateur par email
                    MailingService2 mailingService = new MailingService2();
                    mailingService.SendTokenByEmail(confirmationToken, model.Email, model.UserName);

                    return View("RegisterActivation");
                }
                catch (MembershipCreateUserException e)
                {
                    ModelState.AddModelError("", ErrorCodeToString(e.StatusCode));
                }
            }

            // Si nous sommes arrivés là, quelque chose a échoué, réafficher le formulaire
            return View(model);
        }

        [AllowAnonymous]
        public ActionResult RegisterConfirmation(string Id)
        {
            if (WebSecurity.ConfirmAccount(Id))
            {
                using (var db = new UsersContext())
                {
                    // Use ConfirmationToken to figure out UserId, then use that to get UserName.
                    int userId = db.Memberships.Single(m => m.ConfirmationToken == Id).UserId;
                    string userName = db.UserProfiles.Single(u => u.UserId == userId).UserName;
                    string EMail = db.UserProfiles.Single(u => u.UserId == userId).Email;
                    // Envoi mail de bienvenue
                    MailingService3 mailingServiceBienvenue = new MailingService3();
                    mailingServiceBienvenue.SendTokenByEmail("", EMail, userName);

                    // Authentificate user
                    FormsAuthentication.SetAuthCookie(userName, true);
                }
                return RedirectToAction("ConfirmationSuccess");


                //WebSecurity.Login(model.UserName, model.Password);
                
            }
            return RedirectToAction("ConfirmationFailure");
        }

        [AllowAnonymous]
        public ActionResult ConfirmationSuccess()
        {
            return View();
        }

        [AllowAnonymous]
        public ActionResult ConfirmationFailure()
        {
            return View();
        }

        [AllowAnonymous]
        public ActionResult RecupAccount()
        {
            return View(new RecupAccountModel());
        }

        [HttpPost]
        [AllowAnonymous]
        public ActionResult RecupAccount(RecupAccountModel model)
        {
            // On vérifie que les deux champs sont remplis
            if (ModelState.IsValid)
            {
                using (UsersContext context = new UsersContext())
                {
                    // Si on trouve un compte qui match avec les infos entrées par l'utilisateur...
                    if (context.UserProfiles.Any(
                            u => u.UserName.Equals(model.UserName, StringComparison.OrdinalIgnoreCase) &&
                                    u.Email.Equals(model.Email, StringComparison.OrdinalIgnoreCase)))
                    {
                        // On crée un token permettant de réinitialiser le mot de passe ...
                        string token = WebSecurity.GeneratePasswordResetToken(model.UserName, 5);

                        // ... et on l'envoit à l'utilisateur par email
                        MailingService mailingService = new MailingService();
                        mailingService.SendTokenByEmail(token, model.Email, model.UserName);

                        return View("RecupAccountConfirmed");
                    }
                    else
                    {
                        ModelState.AddModelError("", "Username or password are wrong.");
                    }
                }
            }
            return View(model);
        }

        [AllowAnonymous]
        public ActionResult ResetPassword(string token)
        {
            var userId = WebSecurity.GetUserIdFromPasswordResetToken(token);

            using (UsersContext context = new UsersContext())
            {
                UserProfile user = context.UserProfiles.Find(userId);
                if (user == null)
                    return View("Error");

                var model = new ResetPasswordModel()
                {
                    Token = token,
                    UserName = user.UserName
                };

                return View(model);
            }
        }

        [HttpPost]
        [AllowAnonymous]
        public ActionResult ResetPassword(ResetPasswordModel model)
        {
            if (ModelState.IsValid)
            {
                if (!model.NewPassword.Equals(model.ConfirmNewPassword))
                {
                    ModelState.AddModelError("", "Passwords do not match.");
                    return View(model);
                }
                WebSecurity.ResetPassword(model.Token, model.NewPassword);
                WebSecurity.Login(model.UserName, model.NewPassword);
                return RedirectToAction("Index", "Home");
            }
            return View(model);
        }

        //
        // POST: /Account/Disassociate

        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Disassociate(string provider, string providerUserId)
        {
            string ownerAccount = OAuthWebSecurity.GetUserName(provider, providerUserId);
            ManageMessageId? message = null;

            // Dissocier uniquement le compte si l'utilisateur actuellement connecté est le propriétaire
            if (ownerAccount == User.Identity.Name)
            {
                // Utiliser une transaction pour empêcher l'utilisateur de supprimer ses dernières informations d'identification de connexion
                using (var scope = new TransactionScope(TransactionScopeOption.Required, new TransactionOptions { IsolationLevel = IsolationLevel.Serializable }))
                {
                    bool hasLocalAccount = OAuthWebSecurity.HasLocalAccount(WebSecurity.GetUserId(User.Identity.Name));
                    if (hasLocalAccount || OAuthWebSecurity.GetAccountsFromUserName(User.Identity.Name).Count > 1)
                    {
                        OAuthWebSecurity.DeleteAccount(provider, providerUserId);
                        scope.Complete();
                        message = ManageMessageId.RemoveLoginSuccess;
                    }
                }
            }

            return RedirectToAction("Manage", new { Message = message });
        }

        //
        // GET: /Account/Manage

        public ActionResult Manage(ManageMessageId? message)
        {
            ViewBag.StatusMessage =
                message == ManageMessageId.ChangePasswordSuccess ? "Votre mot de passe a été modifié."
                : message == ManageMessageId.SetPasswordSuccess ? "Votre mot de passe a été défini."
                : message == ManageMessageId.RemoveLoginSuccess ? "La connexion externe a été supprimée."
                : "";
            ViewBag.HasLocalPassword = OAuthWebSecurity.HasLocalAccount(WebSecurity.GetUserId(User.Identity.Name));
            ViewBag.ReturnUrl = Url.Action("Manage");

            // Pour les scores du user
            UsersContext db = new UsersContext();
            UserProfile user = db.UserProfiles.FirstOrDefault(u => u.UserName.Equals(System.Web.HttpContext.Current.User.Identity.Name));
            
            ViewBag.n1 = user.UserNuts1.ToString();
            ViewBag.n2 = user.UserNuts2.ToString();
            ViewBag.n3 = user.UserNuts3.ToString();
            ViewBag.b = user.UserBonus.ToString();
            ViewBag.levelreached = user.UserLevel.ToString();

            ViewBag.meilleurbonus = db.UserProfiles.Max(u => u.UserBonus).ToString();
            int j1 = db.UserProfiles.Max(u => u.UserBonus);
            string jj1 = db.UserProfiles.FirstOrDefault(u => u.UserBonus.Equals(j1)).UserName;
            ViewBag.meilleurn1 = db.UserProfiles.Max(u => u.UserNuts1).ToString();
            int j2 = db.UserProfiles.Max(u => u.UserNuts1);
            string jj2 = db.UserProfiles.FirstOrDefault(u => u.UserNuts1.Equals(j2)).UserName;
            ViewBag.meilleurn2 = db.UserProfiles.Max(u => u.UserNuts2).ToString();
            int j3 = db.UserProfiles.Max(u => u.UserNuts2);
            string jj3 = db.UserProfiles.FirstOrDefault(u => u.UserNuts2.Equals(j3)).UserName;
            ViewBag.meilleurn3 = db.UserProfiles.Max(u => u.UserNuts3).ToString();
            int j4 = db.UserProfiles.Max(u => u.UserNuts3);
            string jj4 = db.UserProfiles.FirstOrDefault(u => u.UserNuts3.Equals(j4)).UserName;

            ViewBag.meilleurn3user = jj4;
            ViewBag.meilleurn2user = jj3;
            ViewBag.meilleurn1user = jj2;
            ViewBag.meilleurbonususer = jj1;

            return View();
        }

        //
        // POST: /Account/Manage

        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Manage(LocalPasswordModel model)
        {
            bool hasLocalAccount = OAuthWebSecurity.HasLocalAccount(WebSecurity.GetUserId(User.Identity.Name));
            ViewBag.HasLocalPassword = hasLocalAccount;
            ViewBag.ReturnUrl = Url.Action("Manage");
            if (hasLocalAccount)
            {
                if (ModelState.IsValid)
                {
                    // ChangePassword va lever une exception plutôt que de renvoyer la valeur False dans certains scénarios de défaillance.
                    bool changePasswordSucceeded;
                    try
                    {
                        changePasswordSucceeded = WebSecurity.ChangePassword(User.Identity.Name, model.OldPassword, model.NewPassword);
                    }
                    catch (Exception)
                    {
                        changePasswordSucceeded = false;
                    }

                    if (changePasswordSucceeded)
                    {
                        return RedirectToAction("Manage", new { Message = ManageMessageId.ChangePasswordSuccess });
                    }
                    else
                    {
                        ModelState.AddModelError("", "Le mot de passe actuel est incorrect ou le nouveau mot de passe n'est pas valide.");
                    }
                }
            }
            else
            {
                // L'utilisateur n'a pas de mot de passe local. Veuillez donc supprimer les erreurs de validation provoquées par un
                // champ OldPassword manquant
                ModelState state = ModelState["OldPassword"];
                if (state != null)
                {
                    state.Errors.Clear();
                }

                if (ModelState.IsValid)
                {
                    try
                    {
                        WebSecurity.CreateAccount(User.Identity.Name, model.NewPassword);
                        return RedirectToAction("Manage", new { Message = ManageMessageId.SetPasswordSuccess });
                    }
                    catch (Exception)
                    {
                        ModelState.AddModelError("", String.Format("Le compte local ne peut pas être créé. Un compte portant le même nom \"{0}\" existe peut-être déjà.", User.Identity.Name));
                    }
                }
            }

            // Si nous sommes arrivés là, quelque chose a échoué, réafficher le formulaire
            return View(model);
        }

        //
        // POST: /Account/ExternalLogin

        [HttpPost]
        [AllowAnonymous]
        [ValidateAntiForgeryToken]
        public ActionResult ExternalLogin(string provider, string returnUrl)
        {
            return new ExternalLoginResult(provider, Url.Action("ExternalLoginCallback", new { ReturnUrl = returnUrl }));
        }

        //
        // GET: /Account/ExternalLoginCallback

        [AllowAnonymous]
        public ActionResult ExternalLoginCallback(string returnUrl)
        {
            AuthenticationResult result = OAuthWebSecurity.VerifyAuthentication(Url.Action("ExternalLoginCallback", new { ReturnUrl = returnUrl }));
            if (!result.IsSuccessful)
            {
                return RedirectToAction("ExternalLoginFailure");
            }

            if (OAuthWebSecurity.Login(result.Provider, result.ProviderUserId, createPersistentCookie: false))
            {
                return RedirectToLocal(returnUrl);
            }

            if (User.Identity.IsAuthenticated)
            {
                // Si l'utilisateur actuel est connecté, ajoutez le nouveau compte
                OAuthWebSecurity.CreateOrUpdateAccount(result.Provider, result.ProviderUserId, User.Identity.Name);
                return RedirectToLocal(returnUrl);
            }
            else
            {
                // L'utilisateur est nouveau. Demander le nom d'appartenance souhaité
                string loginData = OAuthWebSecurity.SerializeProviderUserId(result.Provider, result.ProviderUserId);
                ViewBag.ProviderDisplayName = OAuthWebSecurity.GetOAuthClientData(result.Provider).DisplayName;
                ViewBag.ReturnUrl = returnUrl;
                return View("ExternalLoginConfirmation", new RegisterExternalLoginModel { UserName = result.UserName, ExternalLoginData = loginData });
            }
        }

        //
        // POST: /Account/ExternalLoginConfirmation

        [HttpPost]
        [AllowAnonymous]
        [ValidateAntiForgeryToken]
        public ActionResult ExternalLoginConfirmation(RegisterExternalLoginModel model, string returnUrl)
        {
            string provider = null;
            string providerUserId = null;

            if (User.Identity.IsAuthenticated || !OAuthWebSecurity.TryDeserializeProviderUserId(model.ExternalLoginData, out provider, out providerUserId))
            {
                return RedirectToAction("Manage");
            }

            if (ModelState.IsValid)
            {
                // Insérer un nouvel utilisateur dans la base de données
                using (UsersContext db = new UsersContext())
                {
                    UserProfile user = db.UserProfiles.FirstOrDefault(u => u.UserName.ToLower() == model.UserName.ToLower());
                    // Vérifier si l'utilisateur n'existe pas déjà
                    if (user == null)
                    {
                        // Insérer le nom dans la table des profils
                        db.UserProfiles.Add(new UserProfile { UserName = model.UserName });
                        db.SaveChanges();

                        OAuthWebSecurity.CreateOrUpdateAccount(provider, providerUserId, model.UserName);
                        OAuthWebSecurity.Login(provider, providerUserId, createPersistentCookie: false);

                        return RedirectToLocal(returnUrl);
                    }
                    else
                    {
                        ModelState.AddModelError("UserName", "Le nom d'utilisateur existe déjà. Entrez un nom d'utilisateur différent.");
                    }
                }
            }

            ViewBag.ProviderDisplayName = OAuthWebSecurity.GetOAuthClientData(provider).DisplayName;
            ViewBag.ReturnUrl = returnUrl;
            return View(model);
        }

        //
        // GET: /Account/ExternalLoginFailure

        [AllowAnonymous]
        public ActionResult ExternalLoginFailure()
        {
            return View();
        }

        [AllowAnonymous]
        [ChildActionOnly]
        public ActionResult ExternalLoginsList(string returnUrl)
        {
            ViewBag.ReturnUrl = returnUrl;
            return PartialView("_ExternalLoginsListPartial", OAuthWebSecurity.RegisteredClientData);
        }

        [ChildActionOnly]
        public ActionResult RemoveExternalLogins()
        {
            ICollection<OAuthAccount> accounts = OAuthWebSecurity.GetAccountsFromUserName(User.Identity.Name);
            List<ExternalLogin> externalLogins = new List<ExternalLogin>();
            foreach (OAuthAccount account in accounts)
            {
                AuthenticationClientData clientData = OAuthWebSecurity.GetOAuthClientData(account.Provider);

                externalLogins.Add(new ExternalLogin
                {
                    Provider = account.Provider,
                    ProviderDisplayName = clientData.DisplayName,
                    ProviderUserId = account.ProviderUserId,
                });
            }

            ViewBag.ShowRemoveButton = externalLogins.Count > 1 || OAuthWebSecurity.HasLocalAccount(WebSecurity.GetUserId(User.Identity.Name));
            return PartialView("_RemoveExternalLoginsPartial", externalLogins);
        }

        #region Applications auxiliaires
        private ActionResult RedirectToLocal(string returnUrl)
        {
            if (Url.IsLocalUrl(returnUrl))
            {
                return Redirect(returnUrl);
            }
            else
            {
                return RedirectToAction("Index", "Home");
            }
        }

        public enum ManageMessageId
        {
            ChangePasswordSuccess,
            SetPasswordSuccess,
            RemoveLoginSuccess,
        }

        internal class ExternalLoginResult : ActionResult
        {
            public ExternalLoginResult(string provider, string returnUrl)
            {
                Provider = provider;
                ReturnUrl = returnUrl;
            }

            public string Provider { get; private set; }
            public string ReturnUrl { get; private set; }

            public override void ExecuteResult(ControllerContext context)
            {
                OAuthWebSecurity.RequestAuthentication(Provider, ReturnUrl);
            }
        }

        private static string ErrorCodeToString(MembershipCreateStatus createStatus)
        {
            // Consultez http://go.microsoft.com/fwlink/?LinkID=177550 pour
            // obtenir la liste complète des codes d'état.
            switch (createStatus)
            {
                case MembershipCreateStatus.DuplicateUserName:
                    return "Le nom d'utilisateur existe déjà. Entrez un nom d'utilisateur différent.";

                case MembershipCreateStatus.DuplicateEmail:
                    return "Un nom d'utilisateur pour cette adresse de messagerie existe déjà. Entrez une adresse de messagerie différente.";

                case MembershipCreateStatus.InvalidPassword:
                    return "Le mot de passe fourni n'est pas valide. Entrez une valeur de mot de passe valide.";

                case MembershipCreateStatus.InvalidEmail:
                    return "L'adresse de messagerie fournie n'est pas valide. Vérifiez la valeur et réessayez.";

                case MembershipCreateStatus.InvalidAnswer:
                    return "La réponse de récupération du mot de passe fournie n'est pas valide. Vérifiez la valeur et réessayez.";

                case MembershipCreateStatus.InvalidQuestion:
                    return "La question de récupération du mot de passe fournie n'est pas valide. Vérifiez la valeur et réessayez.";

                case MembershipCreateStatus.InvalidUserName:
                    return "Le nom d'utilisateur fourni n'est pas valide. Vérifiez la valeur et réessayez.";

                case MembershipCreateStatus.ProviderError:
                    return "Le fournisseur d'authentification a retourné une erreur. Vérifiez votre entrée et réessayez. Si le problème persiste, contactez votre administrateur système.";

                case MembershipCreateStatus.UserRejected:
                    return "La demande de création d'utilisateur a été annulée. Vérifiez votre entrée et réessayez. Si le problème persiste, contactez votre administrateur système.";

                default:
                    return "Une erreur inconnue s'est produite. Vérifiez votre entrée et réessayez. Si le problème persiste, contactez votre administrateur système.";
            }
        }
        #endregion
    }
}
