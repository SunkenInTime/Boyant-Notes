class CloudStrorageException implements Exception {
  const CloudStrorageException();
}

//Create
class CouldNoteCreateNoteException extends CloudStrorageException {}

// Read
class CouldNotGetAllNoteException extends CloudStrorageException {}

class CouldNotGetAllTodoListException extends CloudStrorageException {}

// Update
class CouldNotUpdateNoteException extends CloudStrorageException {}

class CouldNotUpdateTodoListException extends CloudStrorageException {}

class CouldNotUpdateCheckException extends CloudStrorageException {}

class CouldNotUpdateSettingException extends CloudStrorageException {}

// Delete
class CouldNotDeleteNoteException extends CloudStrorageException {}

class CouldNotDeleteTodoListException extends CloudStrorageException {}
