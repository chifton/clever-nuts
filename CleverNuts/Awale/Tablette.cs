using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace CleverNuts
{
    public class Tablette
    {

        private int[] trous;

        public Tablette()
        {
            // Initialisation des boules d'acajou par trou de tablette
            trous = new int[] { 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4 };
        }

        public int[] EtatTablette()
        {
            return trous;
        }

        public int TabletteTrou(int y)
        {
            return trous[y];
        }

        public void SetTabletteTrou(int y, int z)
        {
            trous[y] = z;
        }

    }
}