
export const guardsFn = <T>(record: T, guards: Array<(record: T) => boolean>): boolean => {
  return guards.some(gFn => gFn(record))
}

export default guardsFn