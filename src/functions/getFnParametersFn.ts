
export const getFnParametersFn = (target: any, fnName: string): string[] => {
  let match = target.toString().match(`${fnName}\\((.+)\\)`);

  if (match && match[1]) {
    return match[1].split(',').map((m: any) => String(m).trim());
  }

  return [];
}

export default getFnParametersFn
