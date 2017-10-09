using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace CleverNuts
{
    class CreatePartie
    {
        // Propriétés
        public string joueur1 { get; set; }
        public string joueur2 { get; set; }
        public Joueur player1;
        public Joueur player2;
        public Partie partie;
        bool reponse;

        //Méthodes
        public CreatePartie(string j1, string j2)
        {
            // Affectation aux variables membres
            joueur1 = j1;
            joueur2 = j2;
            // L'initialisation des ordres sera automatique et se choisira dans un futur proche développement du jeu
            player1 = new Joueur(joueur1, 1);
            player2 = new Joueur(joueur2, 2);
            partie = new Partie(player1, player2);
        }
        
        public bool SequenceJeu(string holeT)
        {
            reponse = partie.Game(holeT);
            return reponse;
            // Code de mise en route du programme
            // Faire en sorte d'écrire une seule ligne pour le programme
        }

        public string FindArgument()
        {
            return partie.TrouveArgument();
        }
    }
}