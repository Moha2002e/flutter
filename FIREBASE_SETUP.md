# Guide de Configuration Firebase pour CampusLink

## 📋 Étapes pour configurer Firebase

### 1. Créer un projet Firebase

1. Allez sur [Firebase Console](https://console.firebase.google.com/)
2. Cliquez sur **"Ajouter un projet"** ou **"Add project"**
3. Entrez le nom du projet : **CampusLink**
4. (Optionnel) Activez Google Analytics si vous le souhaitez
5. Cliquez sur **"Créer le projet"**

### 2. Ajouter une application Android

1. Dans le tableau de bord Firebase, cliquez sur l'icône **Android** 📱
2. Renseignez les informations :
   - **Package name** : `com.example.projectexamen`
     - ⚠️ **Important** : Vérifiez que c'est bien le package name dans `android/app/build.gradle.kts` (ligne 24)
   - **App nickname** (optionnel) : CampusLink Android
   - **Debug signing certificate SHA-1** (optionnel pour le développement)
3. Cliquez sur **"Enregistrer l'application"**
4. **Téléchargez** le fichier `google-services.json`
5. **Placez-le** dans le dossier : `android/app/google-services.json`
   - ⚠️ Le fichier doit être directement dans `android/app/`, pas dans un sous-dossier

### 3. Ajouter une application iOS (si vous développez pour iOS)

1. Cliquez sur l'icône **iOS** 🍎
2. Renseignez :
   - **Bundle ID** : Vérifiez dans `ios/Runner.xcodeproj`
   - **App nickname** (optionnel)
3. **Téléchargez** le fichier `GoogleService-Info.plist`
4. **Placez-le** dans : `ios/Runner/GoogleService-Info.plist`

### 4. Activer l'Authentification Email/Password

1. Dans le menu de gauche, allez dans **"Authentication"** (Authentification)
2. Cliquez sur **"Get started"** (Commencer)
3. Allez dans l'onglet **"Sign-in method"**
4. Cliquez sur **"Email/Password"**
5. Activez **"Email/Password"** (première option)
6. Cliquez sur **"Enregistrer"** ou **"Save"**

### 5. Vérifier la configuration Flutter

Les dépendances Firebase sont déjà ajoutées dans `pubspec.yaml` :
- ✅ `firebase_core: ^2.24.0`
- ✅ `firebase_auth: ^4.15.0`

Le plugin Google Services est configuré dans :
- ✅ `android/build.gradle.kts` (classpath)
- ✅ `android/app/build.gradle.kts` (plugin)

### 6. Tester la configuration

1. Assurez-vous que le fichier `google-services.json` est bien dans `android/app/`
2. Exécutez :
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```

### 7. Vérifier que Firebase fonctionne

Une fois l'application lancée, essayez de :
- Créer un compte depuis l'écran d'inscription
- Vous connecter depuis l'écran de connexion

Si tout fonctionne, vous devriez voir les utilisateurs dans la console Firebase sous **Authentication > Users**.

## 🔧 Résolution de problèmes

### Erreur : "Default FirebaseApp is not initialized"

- Vérifiez que `google-services.json` est bien dans `android/app/`
- Vérifiez que le plugin Google Services est bien appliqué dans `android/app/build.gradle.kts`
- Exécutez `flutter clean` puis `flutter pub get`

### Erreur : "Package name mismatch"

- Vérifiez que le package name dans Firebase Console correspond à celui dans `android/app/build.gradle.kts` (ligne 24)
- Le package name doit être exactement : `com.example.projectexamen`

### Erreur : "Email already in use"

- C'est normal ! Cela signifie que Firebase fonctionne et qu'un compte avec cet email existe déjà.

## 📝 Notes importantes

- Le fichier `google-services.json` contient des informations sensibles, ne le commitez pas publiquement si vous utilisez un compte Firebase de production
- Pour la production, créez un projet Firebase séparé
- Le package name doit être unique et correspondre exactement entre Firebase et votre application

## 🎯 Prochaines étapes

Une fois Firebase configuré, vous pouvez :
- Ajouter d'autres méthodes d'authentification (Google, Apple, etc.)
- Configurer Firestore pour stocker des données utilisateur
- Configurer Firebase Storage pour les fichiers
- Ajouter des règles de sécurité

