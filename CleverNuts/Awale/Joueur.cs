using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace CleverNuts
{
    public class Joueur
    {
        // Propriétés
        public string pseudo { get; set; }
        public int ordrejoueur { get; set; }
        public int score { get; set; }
        public int scorebonus { get; set; }

        //Méthodes
        public Joueur(string pseudojoueur, int ordre)
        {
            pseudo = pseudojoueur;
            ordrejoueur = ordre;
            score = 0;
            scorebonus = 0;
        }

        public void Gagne()
        {
            // Code Javascript pour indiquer que le jeu est terminé et qu'il faut gagner
            // Ecrire le code après pour savoir si on a gagné ou pas suivant les deux critères
            //Console.WriteLine("\n\nFélicitations " + pseudo + ", tu remportes la partie, tu peux manger tes noix ou les stocker !\n");
        }
    }
}