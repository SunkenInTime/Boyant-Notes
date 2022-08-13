class CloudStrorageException implements Exception {
  const CloudStrorageException();
}

//Create
class CouldNoteCreateNoteException extends CloudStrorageException {}

// Read
class CouldNotGetAllNoteException extends CloudStrorageException {}

// Update
class CouldNotUpdateNoteException extends CloudStrorageException {}

// Delete
class CouldNotDeleteNoteException extends CloudStrorageException {}
