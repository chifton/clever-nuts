using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Microsoft.AspNet.SignalR;
using Microsoft.AspNet.SignalR.Hubs;
using System.Diagnostics;

namespace CleverNuts.Hubs
{
    [HubName("gameserverfbk")]
    public class gameserverfbk : Hub
    {
        // Liste des users en ligne
        public static List<string> Users = new List<string>();
        public static List<string> UsersNames = new List<string>();
        public static List<string> StatusPlaying = new List<string>();
        private string utilisateurlambda {get; set;}
        private int advar { get; set; }

        // Pour avertir d'une nouvelle connexion
        public override System.Threading.Tasks.Task OnConnected()
        {
            // Demande les infos du joueur
            Send2();

            return base.OnConnected();
        }

        // Pour juste lancer la fenetre de demande d'informations
        public void Send2()
        {
            // Call the addNewMessageToPage method to update clients.
            var context = GlobalHost.ConnectionManager.GetHubContext<gameserverfbk>();

            Clients.Caller.getInformations();

        }

        // Pour récupérer l'ordre et le code du joueur
        public void sendinformationshub(string ordre, string code)
        {
            CreateGroup(Convert.ToInt32(ordre), code); // Le demandeur de partie crée le groupe dans le hub
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

        // Pour créer le groupe de deux joueurs dans le hub
        // On informe également le serveur que les deux joueurs sont en train de joueur
        public void CreateGroup(int ordre, string code)
        {
            if (ordre == 1) // Si c'est le demandeur
            {
                // Création et ajout au groupe
                string currentUserId = GetClientId();
                Groups.Add(currentUserId, code);
                // Pour stocker l'id de l'appelant
                Clients.Caller.stockeId(currentUserId);

                // L'initiateur de la partie a sa fenêtre qui s'aménage et le jeu qui va débuter
                Clients.Caller.returnNameJavascript("FacebookNutter1", code);
            }
            else if(ordre == 2) // Si c'est le receveur
            {
                string currentUserId = GetClientId();
                Groups.Add(currentUserId, code);
                // Pour stocker l'id de l'appelant
                Clients.Caller.stockeId(currentUserId);

                // Le receveur voit aussi sa partie débuter et sa fenetre rafraichie
                Clients.Caller.miseAjourJeuAdversaire("FacebookNutter2", code);
            }
        }

        // Pour jouer chez l'appelant
        public void actualiserJeu(int troup, string groupT)
        {
            // Si son statut est oui, il peut jouer
            //if(StatusPlaying[Users.IndexOf(GetClientId())] == "yes")
            //{
                // Jeu d'un tour d'awalé de l'appelant
                Clients.Caller.jouerawale(troup);
            //}
            //else if(StatusPlaying[Users.IndexOf(GetClientId())] == "no")
            //{
                // Pas possible de jouer car son statut en train de jouer est no
            //    Clients.Caller.pasPossibleDeJouer();
            //}
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

        // Pour mettre à jour la liste des utilisateurs en ligne
        public void Send1(int count)
        {
            // Call the addNewMessageToPage method to update clients.
            var context = GlobalHost.ConnectionManager.GetHubContext<gameserverfbk>();
            context.Clients.All.updateUsersOnlineCount(count);
        }

        // Pour avertir d'une déconnexion
        public override System.Threading.Tasks.Task OnDisconnected()
        {
            // Plus de gestion de liste des joueurs

            /*string clientId = GetClientId();

            if (Users.IndexOf(clientId) > -1)
            {
                UsersNames.RemoveAt(Users.IndexOf(clientId));
                StatusPlaying.RemoveAt(Users.IndexOf(clientId));
                Users.Remove(clientId);
            }

            // Send the current count of users
            //Send1(Users.Count);*/

            return base.OnDisconnected();
        }

        public void Send3(string namecoolgroupe)
        {
            var context = GlobalHost.ConnectionManager.GetHubContext<gameserverfbk>();
            Clients.Group(namecoolgroupe, GetClientId()).finjeuanticipe();
        }

        // Pour supprimer du groupe du hub les deux joueurs en fin de partie
        // Sera appelé deux fois par chacun des deux clients (ou des deux joueurs)
        public void destroyHubGroupe(string groupFin)
        {
            Groups.Remove(GetClientId(), groupFin);
        }

        // Pour déclencher une boîte de dialogue chez l'adversaire et lui dire qu'on est prêt
        public void sayoppponentready(string groupFin)
        {
            Clients.Group(groupFin, GetClientId()).readytoplay();
        }

        // Pour avertir d'une éventuelle reconnexion
        // Désactivé car apparation récurrente de boite de dialogue pour demander les infos
        /*public override System.Threading.Tasks.Task OnReconnected()
        {

            // Demande les infos du joueur
            Send2();

            return base.OnReconnected();
        }*/

        public long retourneNombre()
        {
            return Users.Count;
        }

        // JE CREERAI D'AUTRES FONCTIONS ICI !!!!!
    }
}