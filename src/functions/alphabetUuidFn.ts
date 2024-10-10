
export const alphabetUuid = (size: number, alphabet = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"): string => {
  return Array(size).join().split(',')
    .map(function() { 
      return alphabet.charAt(Math.floor(Math.random() * alphabet.length)); 
    }).join('');
}

export default alphabetUuid
