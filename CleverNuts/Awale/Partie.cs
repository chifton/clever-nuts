using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Diagnostics;

namespace CleverNuts
{
    class Partie : JeuJoueur
    {
        // Propriétés
        private int[] scoreDBLE;
        private string scoredouble;

        // On utilise une tablette et deux  joueurs pour chaque partie
        private Tablette tablette;
        private Joueur joueur1;
        private Joueur joueur2;
        private int debutjeu;
        private int jeu;
        private int jeu2;
        private int tour;
        private int[] tab;
        private int[] tab2;
        private string choix;
        private string[] associechiffreslettres;
        private int choice;
        private int choice2;
        private int nbNoix;
        private int tourjoueur;
        private bool ok;
        private int destination;
        private int nbNoix2;
        private int totaladversaire;
        private int tour3;
        private bool jeupossible;
        private int debutjeu2;
        private int nbNoix3;
        private int t1;
        private int t2;
        private bool bouffepossible;
        private int jeu3;
        private bool okChoix;
        private string argument;
        private int vartour;


        //Méthodes
        public Partie(Joueur Joueur1, Joueur Joueur2)
        {
            joueur1 = Joueur1;
            joueur2 = Joueur2;
            scoreDBLE = new int[2];
            scoredouble = scoreDBLE[0] + " - " + scoreDBLE[1];
            associechiffreslettres = new string[] { "A", "B", "C", "D", "E", "F" };
            tablette = new Tablette();
            tourjoueur = 1;
        }

        public string AfficherScore()
        {
            scoreDBLE[0] = joueur1.scorebonus;
            scoreDBLE[1] = joueur2.scorebonus;
            scoredouble = scoreDBLE[0] + " - " + scoreDBLE[1];
            return scoredouble;
        }

        public void VerifierRegles(Joueur player)
        {
            // Créer la méthode après pour la vérification des règles et le paramétrage des options
        }

        public void Affichage(Joueur j1, Joueur j2)
        {
            // Continuer après
            // Code d'affichage y compris la table graphique et les sauts de ligne et les scores et les processus ici
            tab = EtatTablette();
            Debug.WriteLine(joueur1.pseudo + " VS " + joueur2.pseudo + "   :  " + AfficherScore() + "\n********************************************\n********************************************\n**  F  **  E  **  D  **  C  **  B  **  A  **\n**     **     **     **     **     **     **    " + joueur1.pseudo + " : " + joueur1.score + " noix\n**  " + tab[5] + "  **  " + tab[4] + "  **  " + tab[3] + "  **  " + tab[2] + "  **  " + tab[1] + "  **  " + tab[0] + "  **\n********************************************\n**  A  **  B  **  C  **  D  **  E  **  F  **\n**     **     **     **     **     **     **    " + joueur2.pseudo + " : " + joueur2.score + " noix\n**  " + tab[6] + "  **  " + tab[7] + "  **  " + tab[8] + "  **  " + tab[9] + "  **  " + tab[10] + "  **  " + tab[11] + "  **\n********************************************\n********************************************\n");
        }

        public string TrouveArgument()
        {
            return argument;
        }

        public bool Game(string hole)
        {
            // Changer après les paramètres pour permettre le jeu jusqu'à la fin
            if ((joueur1.score < 25 && joueur2.score < 25) || EtatTablette().Sum() > 6)
            {
                if (tourjoueur == 1)
                {
                    Debug.WriteLine(joueur1.pseudo + ", appuie sur une touche entre A et F correspondant à la case à jouer !\n");
                    okChoix = this.RecupereChoix(joueur1, hole);
                    if(okChoix)
                    {
                        this.Jouer(choix, joueur1.ordrejoueur);
                        tourjoueur = 2;
                        Actualiser();
                    }
                    else
                    {
                      // On ne fait rien. Laisser quand même.  
                    }
                    
                }
                else if (tourjoueur == 2)
                {
                    Debug.WriteLine(joueur2.pseudo + ", appuie sur une touche entre A et F correspondant à la case à jouer !\n");
                    okChoix = this.RecupereChoix(joueur2, hole);
                    if (okChoix)
                    {
                        this.Jouer(choix, joueur2.ordrejoueur);
                        tourjoueur = 1;
                        Actualiser();
                    }
                    else
                    {
                        // On ne fait rien. Laisser quand même. 
                    }

                }
            }

            else
            {
                Console.WriteLine("Oh le jeu est fini !");
                // GESTION DES GAINS
                if (joueur1.score > joueur2.score)
                {
                    joueur1.Gagne();
                }
                else if (joueur2.score > joueur1.score)
                {
                    joueur2.Gagne();
                }
                else if (joueur2.score == joueur1.score)
                {
                    Debug.WriteLine("\n\nFélicitations " + joueur1.pseudo + " et " + joueur2.pseudo + ", vous faites jeu égal, vous pouvez manger vos noix ou les stocker !\n");
                }
            }

            /*// Faire AUTRE PARTIE APRES DANS LE MVC JAVASCRIPT
            Debug.WriteLine("\nUne autre partie ?\n");
            Debug.WriteLine("\nAppuyez sur O ou N !\n");
            DebugKeyInfo continuer = Debug.ReadKey(true);
            while (continuer.Key != DebugKey.O && continuer.Key != DebugKey.N)
            {
                Debug.WriteLine("\nAppuyez sur O ou N !\n");
                continuer = Debug.ReadKey(true);
            }
            if (continuer.Key == DebugKey.O)
            {
                CreatePartie partiesuite = new CreatePartie("Joueur 1", "Joueur 2");
                partiesuite.Go();
            }
            // SINON LA PARTIE SE TERMINE*/

            return okChoix;
        }

        public bool RecupereChoix(Joueur player, string letter)
        {
            //DebugKeyInfo saisie = Debug.ReadKey(true);
            
                // Contrôle si la lettre est bonne et si la case de la lettre n'est pas vide
                if (letter != "A" && letter != "B" && letter != "C" && letter != "D" && letter != "E" && letter != "F")
                {
                    // Retourner string ou Javascript pour demander un autre clic si ailleurs
                    Debug.WriteLine("\n" + player.pseudo + ", saisis une lettre entre A, B, C, D, E et F !\n");
                    //saisie = Debug.ReadKey(true);
                }

                for (int i = 0; i < associechiffreslettres.Length; i++)
                {
                    if (associechiffreslettres[i] == letter)
                    {
                        choice2 = i;
                        break;
                    }
                }

                // Calibration de la case de départ pour tester si le jeu est possible ou pas
                if (player.ordrejoueur == 1)
                {
                    debutjeu2 = choice2;
                    nbNoix3 = EtatTablette()[choice2];
                }
                else if (player.ordrejoueur == 2)
                {
                    debutjeu2 = choice2 + 6;
                    nbNoix3 = EtatTablette()[choice2 + 6];
                }
                
                // Au cas où la boule est dès le début non vide
                ok = true;

                // On part du fait que l'adversaire n'est pas "affamable"
                jeupossible = true;

                // Contrôle pour vérifier si la case choisie est vide de noix
                if (player.ordrejoueur == 1)
                {
                    totaladversaire = TabletteTrou(6) + TabletteTrou(7) + TabletteTrou(8) + TabletteTrou(9) + TabletteTrou(10) + TabletteTrou(11);
                    if (EtatTablette()[choice2] == 0)
                    {
                        // Retourner Javascript ou string pour dire qu'il n'y a pas de boules dans le trou
                        ok = false;
                        Debug.WriteLine("\n" + player.pseudo + ", tu fais quoi là ? Y a pas de noix dedans ! Recommence !\n");
                        argument = "Pas de noix dans la case choisie !";
                        //saisie = Debug.ReadKey(true);
                    }
                    // Contrôle pour voir s'il y a des possibilités de jeu pour ne pas affamer l'adversaire
                    else if (totaladversaire == 0)
                    {
                        jeupossible = false;
                        for (int y = 0; y < 6; y++)
                        {
                            if (ChercheDestination(y, TabletteTrou(y))[1] != 0 || (ChercheDestination(y, TabletteTrou(y))[1] == 0 && ChercheDestination(y, TabletteTrou(y))[0] < 12 && ChercheDestination(y, TabletteTrou(y))[0] > 5))
                            {
                                // Le jeu est possible
                                jeupossible = true;
                                break;
                            }
                        }
                        if (jeupossible == false)
                        {
                            // Retourner Javascript ou string pour dire que tu gagnes toutes les boules au détriment de l'adversaire
                            ok = true;   // Pour continuer avec la fonction "Jouer" et attribuer tout le reste des graines
                            Debug.WriteLine("\n" + player.pseudo + ", tu ne peux plus nourrir ton adversaire. Tu gagnes toutes les graines restantes !");
                            argument = "Tu ne peux plus nourrir ton adversaire. Tu gagnes toutes les graines restantes !";
                        }
                        else if (jeupossible == true && ChercheDestination(debutjeu2, nbNoix3)[1] == 0 && ChercheDestination(debutjeu2, nbNoix3)[0] < 6)
                        {
                            // Retourner Javascript ou string pour dire que le jeu est possible et qu'il ne faut pas affamer l'adversaire
                            ok = false;   // Pour continuer la boucle car l'adversaire n'a pas de noix avec le choix du joueur alors que le jeu est possible
                            Debug.WriteLine("\n" + player.pseudo + ", Tu es obligé de nourrir ton adversaire ! Choisis une autre case !");
                            argument = "Tu es obligé de nourrir ton adversaire ! Choisis une autre case !";
                            //saisie = Debug.ReadKey(true);
                        }
                    }
                }
                else if (player.ordrejoueur == 2)
                {
                    totaladversaire = TabletteTrou(0) + TabletteTrou(1) + TabletteTrou(2) + TabletteTrou(3) + TabletteTrou(4) + TabletteTrou(5);
                    if (EtatTablette()[choice2 + 6] == 0)
                    {
                        // Retourner Javascript ou string pour dire qu'il n'y a pas de boules dans le trou
                        ok = false;
                        Debug.WriteLine("\n" + player.pseudo + ", tu fais quoi là ? Y a pas de noix dedans ! Recommence !\n");
                        argument = "Pas de noix dans la case choisie !";
                        //saisie = Debug.ReadKey(true);
                    }
                    // Contrôle pour voir s'il y a des possibilités de jeu pour ne pas affamer l'adversaire
                    else if (totaladversaire == 0)
                    {
                        jeupossible = false;
                        for (int y = 6; y < 12; y++)
                        {
                            if (ChercheDestination(y, TabletteTrou(y))[1] != 0 || (ChercheDestination(y, TabletteTrou(y))[1] == 0 && ChercheDestination(y, TabletteTrou(y))[0] < 6 && ChercheDestination(y, TabletteTrou(y))[0] >= 0))
                            {
                                // Le jeu est possible
                                jeupossible = true;
                                break;
                            }
                        }
                        if (jeupossible == false)
                        {
                            // Retourner Javascript ou string pour dire que tu gagnes toutes les boules au détriment de l'adversaire
                            ok = true;   // Pour continuer avec la fonction "Jouer" et attribuer tout le reste des graines
                            Debug.WriteLine("\n" + player.pseudo + ", tu ne peux plus nourrir ton adversaire. Tu gagnes toutes les graines restantes !");
                            argument = "Tu ne peux plus nourrir ton adversaire. Tu gagnes toutes les graines restantes !";
                        }
                        else if (jeupossible == true && ChercheDestination(debutjeu2, nbNoix3)[1] == 0 && ChercheDestination(debutjeu2, nbNoix3)[0] > 5)
                        {
                            // Retourner Javascript ou string pour dire que le jeu est possible et qu'il ne faut pas affamer l'adversaire
                            ok = false;   // Pour continuer la boucle car l'adversaire n'a pas de noix avec le choix du joueur alors que le jeu est possible
                            Debug.WriteLine("\n" + player.pseudo + ", Tu es obligé de nourrir ton adversaire ! Choisis une autre case !");
                            argument = "Tu es obligé de nourrir ton adversaire ! Choisis une autre case !";
                            //saisie = Debug.ReadKey(true);
                        }
                    }
                }

            if(ok == true)
            {
                // Si une bonne lettre a été rentrée par le joueur  
                choix = letter;
                return ok;
            }
            else
            {
                return ok;
            }
        }

        public void Actualiser()
        {
            Affichage(joueur1, joueur2);
            // Autres méthodes de gestion des scores et autres ici
        }

        public void Jouer(string trou, int ordjoueur)
        {
            // Code après pour juste jouer : contrôle dans la classe Partie

            // Si le jeu est toujours possible et qu'on affame pas l'adversaire
            if (jeupossible == true)
            {
                // On part du fait que l'on peut bouffer les noix à la fin de la distribution
                bouffepossible = true;

                for (int i = 0; i < associechiffreslettres.Length; i++)
                {
                    if (associechiffreslettres[i] == trou)
                    {
                        choice = i;
                        break;
                    }
                }

                // Contrôle pour calibrer la case de départ
                if (ordjoueur == 1)
                {
                    debutjeu = choice + 1;
                    nbNoix = EtatTablette()[choice];
                    jeu = debutjeu;
                }
                else if (ordjoueur == 2)
                {
                    debutjeu = choice + 7;
                    nbNoix = EtatTablette()[choice + 6];
                    jeu = debutjeu;
                }
                if (debutjeu == 12)
                {
                    debutjeu = 0;
                    jeu = debutjeu;
                }

                // Vidange du trou choisi
                if (debutjeu == 0)
                {
                    SetTabletteTrou(11, 0);
                }
                else
                {
                    SetTabletteTrou(debutjeu - 1, 0);
                }

                //Aucun tour de table au départ
                tour = 0;
                vartour = 0;

                // Boucle de jeu
                // Mettre des contrôles pour les règles après
                // Distribuer les noix
                do
                {
                    if (vartour == 12)
                    {
                        vartour = 0;
                        tour++;
                    }
                    // Un tour a déjà été effectué
                    if (jeu > 11)
                    {
                        jeu = 0;
                    }
                    // On saute le trou de départ à chaque fois (si un tour est déjà fait)
                    if (jeu != 11 && jeu == debutjeu - 1)
                    {
                        jeu++;
                    }
                    // Si un tour a déjà été fait, on saute le trou N°0 (il faut une condition particulière)
                    if (jeu == 11 && debutjeu == 0)
                    {
                        jeu = 0;
                    }
                    nbNoix--;
                    vartour++;
                    SetTabletteTrou(jeu, TabletteTrou(jeu) + 1);
                    jeu++;
                } while (nbNoix > 0);


                // Bouffer les noix et calibrer le trou de départ de bouffe des noix
                if (jeu == 0)
                {
                    jeu2 = 11;
                }
                else
                {
                    jeu2 = jeu - 1;
                }


                // Contrôle pour voir si l'adversaire va etre totalement affamé ou pas et si la bouffe est possible
                if (ordjoueur == 1)
                {
                    t1 = 0;
                    if (jeu2 > 5 && jeu2 < 12)
                    {
                        // On vérifie d'abord s'il bouffe tout à partir de jeu2
                        for (int o = jeu2; o > 5; o--)
                        {
                            if (TabletteTrou(o) == 2 || TabletteTrou(o) == 3)
                            {
                                t1++;
                            }
                        }
                        if (jeu2 != 11)
                        {
                            // On vérifie si le nombre de noix avant jeu2 est égal à 0 ou pas
                            jeu3 = jeu2 + 1;
                            for (int g = jeu3; g < 12; g++)
                            {
                                if (TabletteTrou(g) == 0)
                                {
                                    t1++;
                                }
                            }
                        }
                    }
                    if (t1 == 6)   // Tous les trous de l'adversaire sont bouffables et il n'aura plus de noix à la fin de ce jeu
                    {
                        bouffepossible = false;
                    }
                }
                else if (ordjoueur == 2)
                {
                    t2 = 0;
                    if (jeu2 >= 0 && jeu2 < 6)
                    {
                        // On vérifie d'abord s'il bouffe tout à partir de jeu2
                        for (int o = jeu2; o >= 0; o--)
                        {
                            if (TabletteTrou(o) == 2 || TabletteTrou(o) == 3)
                            {
                                t2++;
                            }
                        }
                        if (jeu2 != 5)
                        {
                            // On vérifie si le nombre de noix avant jeu2 est égal à 0 ou pas
                            jeu3 = jeu2 + 1;
                            for (int g = jeu3; g < 6; g++)
                            {
                                if (TabletteTrou(g) == 0)
                                {
                                    t2++;
                                }
                            }
                        }
                    }
                    if (t2 == 6)   // Tous les trous de l'adversaire sont bouffables et il n'aura plus de noix à la fin de ce jeu
                    {
                        bouffepossible = false;
                    }
                }

                // Si la bouffe est possible, on bouffe
                if (bouffepossible == true)
                {
                    // On bouffe les noix de l'adversaire si on a 2 ou 3 boules dans les trous
                    if (ordjoueur == 1)
                    {
                        if (jeu2 > 5 && jeu2 < 12)
                        {
                            for (int o = jeu2; o > 5; o--)
                            {
                                if (TabletteTrou(o) != 2 && TabletteTrou(o) != 3)
                                {
                                    break;
                                }
                                else if (TabletteTrou(o) == 2 || TabletteTrou(o) == 3)
                                {
                                    joueur1.score = joueur1.score + TabletteTrou(o);
                                    SetTabletteTrou(o, 0);
                                }
                            }
                        }
                    }
                    else if (ordjoueur == 2)
                    {
                        if (jeu2 >= 0 && jeu2 < 6)
                        {
                            for (int o = jeu2; o >= 0; o--)
                            {
                                if (TabletteTrou(o) != 2 && TabletteTrou(o) != 3)
                                {
                                    break;
                                }
                                else if (TabletteTrou(o) == 2 || TabletteTrou(o) == 3)
                                {
                                    joueur2.score = joueur2.score + TabletteTrou(o);
                                    SetTabletteTrou(o, 0);
                                }
                            }
                        }
                    }
                }
                // else ... si la bouffe n'est pas possible, on ne fait rien : COUP d'ECLAT
            }
            else  // Si le jeu n'est pas possible pour nourrir l'adversaire
            {
                if (ordjoueur == 1)
                {
                    for (int t = 0; t < 6; t++)
                    {
                        joueur1.score = joueur1.score + TabletteTrou(t);
                        this.SetTabletteTrou(t, 0);
                    }
                }
                else if (ordjoueur == 2)
                {
                    for (int t = 6; t < 12; t++)
                    {
                        joueur2.score = joueur2.score + TabletteTrou(t);
                        this.SetTabletteTrou(t, 0);
                    }
                }
            }

            // Mise à jour des scores bonus
            joueur1.scorebonus = joueur1.score * 10;
            joueur2.scorebonus = joueur2.score * 10;
        }

        // Méthodes pour la gestion de la tablette de jeu
        public int[] EtatTablette()
        {
            return tablette.EtatTablette();
        }

        public int TabletteTrou(int y)
        {
            return tablette.TabletteTrou(y);
        }

        public void SetTabletteTrou(int y, int z)
        {
            tablette.SetTabletteTrou(y, z);
        }

        public int[] ChercheDestination(int dJeuavant, int noixPrises)
        {
            // Cherche la destination
            nbNoix2 = noixPrises;
            destination = 0;
            tour3 = 0;
            while (nbNoix2 > 11)
            {
                nbNoix2 = nbNoix2 - 11;
                tour3++;
            }
            destination = dJeuavant + nbNoix2;
            tab2 = new int[2] { destination, tour3 };
            return tab2;
        }
    }
}