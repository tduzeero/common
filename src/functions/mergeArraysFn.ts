
export const mergeArraysFn = <T>(left: Array<T>, right: Array<T>): Array<T> => {
  let biggestArray = left.length > right.length ? left : right
  return biggestArray.map((value, index) => right[index] ?? left[index])
}

export default mergeArraysFn