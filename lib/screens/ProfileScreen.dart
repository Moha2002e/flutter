import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../styles/colors.dart';
import '../styles/sizes.dart';
import '../styles/spacings.dart';
import '../styles/texts.dart';
import '../services/firebase_auth.dart';
import '../utils/user_utils.dart';

/// Écran de profil utilisateur
/// Permet à l'utilisateur de voir ses informations et de modifier son mot de passe
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  static const String routeName = '/profile';

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Contrôleurs pour les champs de texte
  final TextEditingController controleurMotDePasseActuel = TextEditingController();
  final TextEditingController controleurNouveauMotDePasse = TextEditingController();
  final TextEditingController controleurConfirmationMotDePasse = TextEditingController();
  
  // Clé pour valider le formulaire
  final _cleFormulaire = GlobalKey<FormState>();
  
  // Variables pour gérer l'état de l'écran
  bool _enEditionMotDePasse = false;
  bool _masquerMotDePasseActuel = true;
  bool _masquerNouveauMotDePasse = true;
  bool _masquerConfirmationMotDePasse = true;

  @override
  void dispose() {
    // Libère les ressources des contrôleurs
    controleurMotDePasseActuel.dispose();
    controleurNouveauMotDePasse.dispose();
    controleurConfirmationMotDePasse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Récupère l'utilisateur actuellement connecté
    final utilisateur = FirebaseAuthService.currentUser;
    final nomUtilisateur = getUserName(utilisateur);
    
    // Récupère l'email de l'utilisateur
    String emailUtilisateur = '';
    if (utilisateur != null && utilisateur.email != null) {
      emailUtilisateur = utilisateur.email!;
    }

    return Scaffold(
      body: SizedBox.expand(
        child: DecoratedBox(
          decoration: const BoxDecoration(gradient: kBackgroundGradient),
          child: SafeArea(
            child: LayoutBuilder(
              builder: (context, contraintes) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: contraintes.maxHeight),
                    child: Padding(
                      padding: const EdgeInsets.all(kHomeContentPadding),
                      child: Column(
                        children: [
                          // Bouton retour
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  width: kBackButtonSize,
                                  height: kBackButtonSize,
                                  decoration: const BoxDecoration(
                                    color: kWhiteColor,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.arrow_back, color: Colors.black),
                                ),
                              ),
                            ],
                          ),
                          
                          const SizedBox(height: kSpacingAfterHeader),
                          
                          // Avatar de l'utilisateur
                          Container(
                            width: kProfileAvatarSize,
                            height: kProfileAvatarSize,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: kWhiteColor.withOpacity(kProfileAvatarOpacity),
                              border: Border.all(
                                color: kWhiteColor,
                                width: kProfileAvatarBorderWidth,
                              ),
                            ),
                            child: const Icon(
                              Icons.person,
                              size: kProfileAvatarIconSize,
                              color: kWhiteColor,
                            ),
                          ),
                          
                          const SizedBox(height: kSpacingAfterGreeting),
                          
                          // Informations utilisateur (nom et email)
                          Column(
                            children: [
                              Text(
                                nomUtilisateur,
                                style: kGreetingText.copyWith(fontSize: kGreetingFontSize),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: kSmallSpace),
                              Text(
                                emailUtilisateur,
                                style: kLabelText.copyWith(fontSize: kProfileEmailFontSize),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          
                          const SizedBox(height: kSpacingBeforeForm),
                          
                          // Formulaire de modification du mot de passe
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: kHorizontalPaddingL),
                            child: Form(
                              key: _cleFormulaire,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Affiche soit le bouton "Modifier", soit les champs de mot de passe
                                  if (!_enEditionMotDePasse)
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            _enEditionMotDePasse = true;
                                          });
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: kWhiteColor,
                                          foregroundColor: kMainButtonColor,
                                          padding: const EdgeInsets.symmetric(vertical: kInputFieldPadding),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(kInputFieldBorderRadius),
                                          ),
                                        ),
                                        child: Text(
                                          'Modifier le mot de passe',
                                          style: kProfileButtonText.copyWith(color: kMainButtonColor),
                                        ),
                                      ),
                                    ),
                                  
                                  // Affiche les champs de mot de passe si on est en mode édition
                                  if (_enEditionMotDePasse) ...[
                                    // Champ Mot de passe actuel
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Mot de passe actuel', style: kLabelText),
                                        const SizedBox(height: kSpacingBetweenLabelAndField),
                                        TextFormField(
                                          controller: controleurMotDePasseActuel,
                                          obscureText: _masquerMotDePasseActuel,
                                          style: kInputText,
                                          decoration: InputDecoration(
                                            filled: true,
                                            fillColor: kWhiteColor,
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(kInputFieldBorderRadius),
                                              borderSide: BorderSide.none,
                                            ),
                                            contentPadding: const EdgeInsets.symmetric(
                                              horizontal: kInputFieldPadding,
                                              vertical: kInputFieldPadding,
                                            ),
                                            suffixIcon: IconButton(
                                              icon: Icon(
                                                _masquerMotDePasseActuel
                                                    ? Icons.visibility_outlined
                                                    : Icons.visibility_off_outlined,
                                                color: Colors.black,
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  _masquerMotDePasseActuel = !_masquerMotDePasseActuel;
                                                });
                                              },
                                            ),
                                          ),
                                          validator: (valeur) {
                                            if (valeur == null || valeur.isEmpty) {
                                              return 'Veuillez entrer votre mot de passe actuel';
                                            }
                                            return null;
                                          },
                                        ),
                                      ],
                                    ),
                                    
                                    const SizedBox(height: kSpacingBetweenFields),
                                    
                                    // Champ Nouveau mot de passe
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Nouveau mot de passe', style: kLabelText),
                                        const SizedBox(height: kSpacingBetweenLabelAndField),
                                        TextFormField(
                                          controller: controleurNouveauMotDePasse,
                                          obscureText: _masquerNouveauMotDePasse,
                                          style: kInputText,
                                          decoration: InputDecoration(
                                            filled: true,
                                            fillColor: kWhiteColor,
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(kInputFieldBorderRadius),
                                              borderSide: BorderSide.none,
                                            ),
                                            contentPadding: const EdgeInsets.symmetric(
                                              horizontal: kInputFieldPadding,
                                              vertical: kInputFieldPadding,
                                            ),
                                            suffixIcon: IconButton(
                                              icon: Icon(
                                                _masquerNouveauMotDePasse
                                                    ? Icons.visibility_outlined
                                                    : Icons.visibility_off_outlined,
                                                color: Colors.black,
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  _masquerNouveauMotDePasse = !_masquerNouveauMotDePasse;
                                                });
                                              },
                                            ),
                                          ),
                                          validator: (valeur) {
                                            if (valeur == null || valeur.isEmpty) {
                                              return 'Veuillez entrer un nouveau mot de passe';
                                            }
                                            if (valeur.length < kMinPasswordLength) {
                                              return 'Le mot de passe doit contenir au moins $kMinPasswordLength caractères';
                                            }
                                            return null;
                                          },
                                        ),
                                      ],
                                    ),
                                    
                                    const SizedBox(height: kSpacingBetweenFields),
                                    
                                    // Champ Confirmer le nouveau mot de passe
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Confirmer le nouveau mot de passe', style: kLabelText),
                                        const SizedBox(height: kSpacingBetweenLabelAndField),
                                        TextFormField(
                                          controller: controleurConfirmationMotDePasse,
                                          obscureText: _masquerConfirmationMotDePasse,
                                          style: kInputText,
                                          decoration: InputDecoration(
                                            filled: true,
                                            fillColor: kWhiteColor,
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(kInputFieldBorderRadius),
                                              borderSide: BorderSide.none,
                                            ),
                                            contentPadding: const EdgeInsets.symmetric(
                                              horizontal: kInputFieldPadding,
                                              vertical: kInputFieldPadding,
                                            ),
                                            suffixIcon: IconButton(
                                              icon: Icon(
                                                _masquerConfirmationMotDePasse
                                                    ? Icons.visibility_outlined
                                                    : Icons.visibility_off_outlined,
                                                color: Colors.black,
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  _masquerConfirmationMotDePasse = !_masquerConfirmationMotDePasse;
                                                });
                                              },
                                            ),
                                          ),
                                          validator: (valeur) {
                                            if (valeur == null || valeur.isEmpty) {
                                              return 'Veuillez confirmer le nouveau mot de passe';
                                            }
                                            if (valeur != controleurNouveauMotDePasse.text) {
                                              return 'Les mots de passe ne correspondent pas';
                                            }
                                            return null;
                                          },
                                        ),
                                      ],
                                    ),
                                    
                                    const SizedBox(height: kSpacingBeforeButton),
                                    
                                    // Boutons Annuler et Enregistrer
                                    Row(
                                      children: [
                                        Expanded(
                                          child: ElevatedButton(
                                            onPressed: () {
                                              // Annule l'édition et efface les champs
                                              controleurMotDePasseActuel.clear();
                                              controleurNouveauMotDePasse.clear();
                                              controleurConfirmationMotDePasse.clear();
                                              setState(() {
                                                _enEditionMotDePasse = false;
                                              });
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.grey,
                                              foregroundColor: kWhiteColor,
                                              padding: const EdgeInsets.symmetric(vertical: kInputFieldPadding),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(kInputFieldBorderRadius),
                                              ),
                                            ),
                                            child: Text(
                                              'Annuler',
                                              style: kProfileButtonText.copyWith(color: kWhiteColor),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: kSmallSpace),
                                        Expanded(
                                          child: ElevatedButton(
                                            onPressed: _mettreAJourMotDePasse,
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: kWhiteColor,
                                              foregroundColor: kMainButtonColor,
                                              padding: const EdgeInsets.symmetric(vertical: kInputFieldPadding),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(kInputFieldBorderRadius),
                                              ),
                                            ),
                                            child: Text(
                                              'Enregistrer',
                                              style: kProfileButtonText.copyWith(color: kMainButtonColor),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                          
                          const SizedBox(height: kSpacingAfterButton),
                          
                          // Section d'informations utilisateur
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: kHorizontalPaddingL),
                            child: Column(
                              children: [
                                // Ligne Email
                                Container(
                                  padding: const EdgeInsets.all(kInputFieldPadding),
                                  decoration: BoxDecoration(
                                    color: kWhiteColor.withOpacity(kProfileInfoBackgroundOpacity),
                                    borderRadius: BorderRadius.circular(kInputFieldBorderRadius),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(Icons.email_outlined, color: kWhiteColor, size: kProfileInfoIconSize),
                                      const SizedBox(width: kSmallSpace),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Email',
                                              style: kLabelText.copyWith(fontSize: kProfileLabelFontSize),
                                            ),
                                            const SizedBox(height: kProfileInfoSpacing),
                                            Text(emailUtilisateur, style: kProfileInfoValueText),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                
                                const SizedBox(height: kSpacingBetweenFields),
                                
                                // Ligne Date de création
                                Container(
                                  padding: const EdgeInsets.all(kInputFieldPadding),
                                  decoration: BoxDecoration(
                                    color: kWhiteColor.withOpacity(kProfileInfoBackgroundOpacity),
                                    borderRadius: BorderRadius.circular(kInputFieldBorderRadius),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(Icons.calendar_today_outlined, color: kWhiteColor, size: kProfileInfoIconSize),
                                      const SizedBox(width: kSmallSpace),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Compte créé le',
                                              style: kLabelText.copyWith(fontSize: kProfileLabelFontSize),
                                            ),
                                            const SizedBox(height: kProfileInfoSpacing),
                                            Text(formatCreationDate(utilisateur), style: kProfileInfoValueText),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          const SizedBox(height: kSpacingBottomForm),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  /// Met à jour le mot de passe de l'utilisateur
  /// Vérifie les champs, réauthentifie l'utilisateur, puis met à jour le mot de passe
  Future<void> _mettreAJourMotDePasse() async {
    // Valide le formulaire (vérifie que les champs sont remplis correctement)
    if (_cleFormulaire.currentState!.validate()) {
      try {
        final utilisateur = FirebaseAuthService.currentUser;
        if (utilisateur != null && utilisateur.email != null) {
          // Réauthentifie l'utilisateur avec le mot de passe actuel
          final identifiants = EmailAuthProvider.credential(
            email: utilisateur.email!,
            password: controleurMotDePasseActuel.text,
          );
          await utilisateur.reauthenticateWithCredential(identifiants);

          // Met à jour le mot de passe
          await utilisateur.updatePassword(controleurNouveauMotDePasse.text);
          
          // Réinitialise les champs
          controleurMotDePasseActuel.clear();
          controleurNouveauMotDePasse.clear();
          controleurConfirmationMotDePasse.clear();
          
          // Désactive le mode édition
          setState(() {
            _enEditionMotDePasse = false;
          });

          // Affiche un message de succès
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Mot de passe mis à jour avec succès')),
            );
          }
        }
      } on FirebaseAuthException catch (erreur) {
        // Affiche un message d'erreur si la mise à jour échoue
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(_obtenirMessageErreur(erreur.code))),
          );
        }
      } catch (erreur) {
        // Affiche un message d'erreur générique en cas d'erreur inattendue
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erreur lors de la mise à jour: $erreur')),
          );
        }
      }
    }
  }

  /// Convertit le code d'erreur Firebase en message français compréhensible
  String _obtenirMessageErreur(String code) {
    switch (code) {
      case 'wrong-password':
        return 'Mot de passe actuel incorrect.';
      case 'weak-password':
        return 'Le nouveau mot de passe est trop faible.';
      case 'requires-recent-login':
        return 'Veuillez vous reconnecter pour modifier votre mot de passe.';
      default:
        return 'Erreur lors de la mise à jour du mot de passe.';
    }
  }
}
