using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Microsoft.AspNet.SignalR;
using Microsoft.AspNet.SignalR.Hubs;
using System.Diagnostics;

namespace CleverNuts.Hubs
{
    [HubName("gameserver")]
    public class gameserver : Hub
    {
        // Liste des users en ligne
        public static List<string> Users = new List<string>();
        public static List<string> UsersNames = new List<string>();
        public static List<string> StatusPlaying = new List<string>();
        private string utilisateurlambda {get; set;}
        private int advar { get; set; }

        // Pour jouer chez l'appelant
        public void actualiserJeu(int troup, string groupT)
        {
            // Si son statut est oui, il peut jouer
            if(StatusPlaying[Users.IndexOf(GetClientId())] == "yes")
            {
                // Jeu d'un tour d'awalé de l'appelant
                Clients.Caller.jouerawale(troup);
            }
            else if(StatusPlaying[Users.IndexOf(GetClientId())] == "no")
            {
                // Pas possible de jouer car son statut en train de jouer est no
                Clients.Caller.pasPossibleDeJouer();
            }
        }

        // Pour jouer chez l'adversaire
        public void jeuChezAdversaire(int troup2, string groupT2)
        {
            Clients.Group(groupT2, GetClientId()).jouerawale2(troup2);
        }

        public void SendChat(string name, string message, string groupNow)
        {
                Debug.WriteLine(groupNow);
                // Call the addMessage method on all clients
                Clients.Group(groupNow).addMessageChat(name, message);
        }

        // Pour créer le groupe de deux joueurs dans le hub
        // On informe également le serveur que les deux joueurs sont en train de joueur
        public void CreateGroup(string namelui)
        {
            string currentUserId = GetClientId();
            string toConnectTo = Users.ElementAt(advar);
            string strGroupName = GetUniqueGroupName(currentUserId, toConnectTo); // Pour créer un nom de groupe unique
            if (!string.IsNullOrEmpty(toConnectTo))
            {
                Groups.Add(currentUserId, strGroupName);
                Groups.Add(toConnectTo, strGroupName);
                StatusPlaying[Users.IndexOf(currentUserId)] = "yes";
                StatusPlaying[Users.IndexOf(toConnectTo)] = "yes";
            }
            
            // L'initiateur de la partie a sa fenêtre qui s'aménage et le jeu qui va débuter
            Clients.Caller.returnNameJavascript(namelui, strGroupName);
            // Pour stocker l'id de l'appelant
            Clients.Caller.stockeId(GetClientId());

            // Le receveur voit aussi sa partie débuter et sa fenetre rafraichie
            var appelant = UsersNames.ElementAt(Users.IndexOf(currentUserId));
            Clients.Client(toConnectTo).miseAjourJeuAdversaire(appelant, strGroupName);
            // Pour stocker l'id du receveur
            Clients.Client(toConnectTo).stockeId(toConnectTo);
        }

        private string GetUniqueGroupName(string currentUserId, string toConnectTo)
        {
            return (currentUserId.GetHashCode() ^ toConnectTo.GetHashCode()).ToString();
        }

        // Pour mettre à jour la liste des utilisateurs en ligne
        public void Send1(int count)
        {
            // Call the addNewMessageToPage method to update clients.
            var context = GlobalHost.ConnectionManager.GetHubContext<gameserver>();
            context.Clients.All.updateUsersOnlineCount(count);
        }

        // Pour juste lancer la fenetre de demande d'informations
        public void Send2()
        {
            // Call the addNewMessageToPage method to update clients.
            var context = GlobalHost.ConnectionManager.GetHubContext<gameserver>();
            // On appelle aussi la fonction pour demander les infos du joueur
            Clients.Caller.demanderInfos();
        }

        public void Send3(string namecoolgroupe)
        {
            var context = GlobalHost.ConnectionManager.GetHubContext<gameserver>();
            Clients.Group(namecoolgroupe, GetClientId()).finjeuanticipe();
        }

        // Pour avertir d'une nouvelle connexion
        public override System.Threading.Tasks.Task OnConnected()
        {
            // Demande les infos du joueur
            Send2();

            return base.OnConnected();
        }

        // Pour avertir d'une éventuelle reconnexion
        // Désactivé car apparation récurrente de boite de dialogue pour demander les infos
        /*public override System.Threading.Tasks.Task OnReconnected()
        {

            // Demande les infos du joueur
            Send2();

            return base.OnReconnected();
        }*/

        // Pour avertir d'une déconnexion
        public override System.Threading.Tasks.Task OnDisconnected()
        {
            string clientId = GetClientId();

            if (Users.IndexOf(clientId) > -1)
            {
                UsersNames.RemoveAt(Users.IndexOf(clientId));
                StatusPlaying.RemoveAt(Users.IndexOf(clientId));
                Users.Remove(clientId);
            }

            // Send the current count of users
            Send1(Users.Count);

            return base.OnDisconnected();
        }

        public long retourneNombre()
        {
            return Users.Count;
        }

        // Pour récuperer l'id du client qui vient de se connecter au hub
        private string GetClientId()
        {
            string clientId = "";
            if (Context.QueryString["clientId"] != null)
            {
                // clientId passed from application 
                clientId = this.Context.QueryString["clientId"];
            }

            if (string.IsNullOrEmpty(clientId.Trim()))
            {
                clientId = Context.ConnectionId;
            }

            return clientId;
        }

        // Pour mettre à jour la liste des usernames
        public string receiveUsername()
        {
            utilisateurlambda = Clients.Caller.joueurNom;
            Debug.WriteLine(utilisateurlambda);
            miseAjourBase();
            return utilisateurlambda;
        }

        /*// Pour passer le tour de jeu à l'adversaire
        public string tourDeJeu(string groupeDeJeu)
        {
            Clients.OthersInGroup(groupeDeJeu).modifyTourDeJeu();
            Clients.Caller.modifyTourDeJeu2();
            return groupeDeJeu;
        }*/

        public string miseAjourBase()
        {
            string clientId = GetClientId();
            string clientName = utilisateurlambda;

            if (Users.IndexOf(clientId) == -1)
            {
                Debug.WriteLine(clientId + "   " + utilisateurlambda);
                Users.Add(clientId);
                UsersNames.Add(clientName);
                StatusPlaying.Add("no"); // Statut du joueur (jouant ou pas)
            }

            // Send the current count of users
            Send1(Users.Count);

            Clients.Caller.identifierAdversaire();

            return clientName;
        }

        // Pour retrouver un username à partir de son index
        public void usernameAt(int idJoueur)
        {
            advar = idJoueur;
            string nom = UsersNames.ElementAt(idJoueur);
            CreateGroup(nom);
        }

        // Pour retrouver un username à partir de son index
        public void jouetil(int idJoueurJouant)
        {
            string resultat = StatusPlaying[idJoueurJouant];
            // S'il est en train de jouer ou que c'est le joueur demandant la partie
            if (resultat == "yes" || idJoueurJouant == Users.IndexOf(GetClientId()))
            {
                // On retourne à la fonction de javascript pour redemander un autre identifiant
                Clients.Caller.identifierAdversaire();

            }
                // S'il n'est pas en train de jouer
            else if(resultat == "no")
            {
                // On va transmettre le username à UserNameAt
                usernameAt(idJoueurJouant);
            }
        }

        // Pour déclencher une boîte de dialogue chez l'adversaire et lui dire qu'on est prêt
        public void sayoppponentready(string groupFin)
        {
            Clients.Group(groupFin, GetClientId()).readytoplay();
        }

        // Pour supprimer du groupe du hub les deux joueurs en fin de partie
        // Sera appelé deux fois par chacun des deux clients (ou des deux joueurs)
        public void destroyHubGroupe(string groupFin)
        {
            Groups.Remove(GetClientId(), groupFin);
        }

        // JE CREERAI D'AUTRES FONCTIONS ICI !!!!!
    }
}