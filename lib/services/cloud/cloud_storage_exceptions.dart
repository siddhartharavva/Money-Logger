
class CloudStorageException implements Exception {
  const CloudStorageException();
}


// C in crud
 class CouldNotCreateLogException extends CloudStorageException{
 }

// R in crud
 class CouldNotGetAllLogsException extends CloudStorageException{


 }

// U in crud
 class CouldNotUpdateLogException extends CloudStorageException{

 }

 // D in crud
class CouldNotDeleteLogException extends CloudStorageException{

 }