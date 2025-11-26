# Guide de Configuration Firestore pour les Clubs

## 📋 Étapes pour configurer Firestore dans Firebase Console

### 1. Activer Firestore Database

1. Allez sur [Firebase Console](https://console.firebase.google.com/)
2. Sélectionnez votre projet **CampusLink**
3. Dans le menu de gauche, cliquez sur **"Firestore Database"**
4. Cliquez sur **"Créer une base de données"** ou **"Create database"**
5. Choisissez le mode :
   - **Mode test** (pour le développement) - Les règles sont ouvertes pendant 30 jours
   - **Mode production** (pour la production) - Nécessite des règles de sécurité
6. Choisissez l'emplacement de votre base de données (ex: `europe-west`)
7. Cliquez sur **"Activer"** ou **"Enable"**

### 2. Configurer les Règles de Sécurité

1. Dans Firestore Database, allez dans l'onglet **"Règles"** ou **"Rules"**
2. Remplacez le contenu par les règles suivantes :

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Règles pour les clubs
    match /clubs/{clubId} {
      // Tout le monde peut lire les clubs
      allow read: if true;
      
      // Seuls les utilisateurs authentifiés peuvent créer des clubs
      allow create: if request.auth != null;
      
      // Seul le créateur peut modifier le club
      allow update: if request.auth != null && 
                       request.resource.data.createurId == request.auth.uid;
      
      // Seul le créateur peut supprimer le club
      allow delete: if request.auth != null && 
                       resource.data.createurId == request.auth.uid;
      
      // Sous-collection membres
      match /membres/{membreId} {
        // Tout le monde peut lire la liste des membres
        allow read: if true;
        
        // Un utilisateur peut s'ajouter comme membre
        allow create: if request.auth != null && 
                         request.auth.uid == membreId;
        
        // Un utilisateur peut se retirer comme membre
        allow delete: if request.auth != null && 
                         request.auth.uid == membreId;
      }
    }
    
    // Règles pour les annonces
    match /annonces/{annonceId} {
      // Tout le monde peut lire les annonces
      allow read: if true;
      
      // Seuls les utilisateurs authentifiés peuvent créer des annonces
      allow create: if request.auth != null;
      
      // Seul le créateur peut modifier l'annonce
      allow update: if request.auth != null && 
                       request.resource.data.createurId == request.auth.uid;
      
      // Seul le créateur peut supprimer l'annonce
      allow delete: if request.auth != null && 
                       resource.data.createurId == request.auth.uid;
    }
    
    // Règles pour les événements
    match /evenements/{evenementId} {
      // Tout le monde peut lire les événements
      allow read: if true;
      
      // Seuls les utilisateurs authentifiés peuvent créer des événements
      allow create: if request.auth != null;
      
      // Seul le créateur peut modifier l'événement
      allow update: if request.auth != null && 
                       request.resource.data.createurId == request.auth.uid;
      
      // Seul le créateur peut supprimer l'événement
      allow delete: if request.auth != null && 
                       resource.data.createurId == request.auth.uid;
    }
    
    // Règles pour les cours
    match /cours/{coursId} {
      // Tout le monde peut lire les cours
      allow read: if true;
      
      // Seuls les utilisateurs authentifiés peuvent créer des cours
      allow create: if request.auth != null;
      
      // Seul le créateur peut modifier le cours
      allow update: if request.auth != null && 
                       request.resource.data.createurId == request.auth.uid;
      
      // Seul le créateur peut supprimer le cours
      allow delete: if request.auth != null && 
                       resource.data.createurId == request.auth.uid;
    }
  }
}
```

3. Cliquez sur **"Publier"** ou **"Publish"**

### 3. Créer un Index (si nécessaire)

Si vous voyez une erreur concernant un index manquant lors de l'utilisation de `orderBy` :

1. Cliquez sur le lien dans l'erreur pour créer l'index automatiquement
2. Ou allez dans l'onglet **"Index"** de Firestore
3. Créez des index composites pour :
   - Collection: `clubs` - Champs: `dateCreation` (Descending)
   - Collection: `annonces` - Champs: `dateCreation` (Descending)
   - Collection: `evenements` - Champs: `dateCreation` (Descending)
   - Collection: `cours` - Champs: `dateCreation` (Descending)

### 4. Tester la Configuration

1. Lancez votre application Flutter
2. Connectez-vous avec un compte
3. Depuis HomeScreen, cliquez sur le bouton **"Clubs"**
4. Cliquez sur le bouton **"+"** pour créer un club
5. Remplissez le formulaire et créez un club
6. Vérifiez dans Firebase Console > Firestore Database que le club apparaît dans la collection `clubs`

## 📊 Structure des Données

### Collection `clubs`

Chaque document contient :
- `nom` (string) : Nom du club
- `description` (string) : Description du club
- `nombreMembres` (number) : Nombre de membres (mis à jour automatiquement)
- `dateCreation` (timestamp) : Date de création
- `createurId` (string) : ID de l'utilisateur créateur

### Sous-collection `membres`

Chaque document représente un membre :
- Document ID = `userId`
- `dateAdhesion` (timestamp) : Date d'adhésion

### Collection `annonces`

Chaque document contient :
- `nom` (string) : Nom de l'annonce
- `description` (string) : Description de l'annonce
- `date` (timestamp) : Date de l'annonce
- `categorie` (string) : Catégorie de l'annonce
- `dateCreation` (timestamp) : Date de création
- `createurId` (string) : ID de l'utilisateur créateur

### Collection `evenements`

Chaque document contient :
- `nom` (string) : Nom de l'événement
- `description` (string) : Description de l'événement
- `date` (timestamp) : Date de l'événement
- `lieu` (string) : Lieu de l'événement
- `dateCreation` (timestamp) : Date de création
- `createurId` (string) : ID de l'utilisateur créateur

### Collection `cours`

Chaque document contient :
- `nom` (string) : Nom du cours
- `date` (timestamp) : Date du cours
- `nomProf` (string) : Nom du professeur
- `local` (string) : Local/salle du cours
- `dateCreation` (timestamp) : Date de création
- `createurId` (string) : ID de l'utilisateur créateur

## 🔧 Utilisation dans le Code

### Créer un club

```dart
await FirebaseFirestoreService.creerClub(
  nom: 'Club de Robotique',
  description: 'Un club pour les passionnés de robotique',
  createurId: utilisateur.uid,
);
```

### Lire tous les clubs

```dart
StreamBuilder<List<Map<String, dynamic>>>(
  stream: FirebaseFirestoreService.obtenirTousLesClubs(),
  builder: (context, snapshot) {
    // Utiliser les données
  },
)
```

### Rejoindre un club

```dart
await FirebaseFirestoreService.rejoindreClub(
  clubId: 'clubId123',
  userId: utilisateur.uid,
);
```

## ⚠️ Notes Importantes

- Le compteur `nombreMembres` est mis à jour automatiquement via des transactions Firestore
- Les transactions garantissent la cohérence des données même en cas d'accès simultanés
- Les règles de sécurité empêchent les utilisateurs non authentifiés de créer des clubs
- Seul le créateur peut modifier ou supprimer son club

## 🎯 Prochaines Étapes

Une fois Firestore configuré, vous pouvez :
- Ajouter des images de profil pour les clubs
- Créer un écran de détails pour chaque club
- Ajouter des fonctionnalités de chat ou d'événements
- Implémenter des notifications pour les nouveaux membres

