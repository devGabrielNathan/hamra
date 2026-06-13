# Helper para criar specialisations de desktop de forma padronizada.
#
{ lib }:
{ profile, sessionName, disableSessions ? [] }:
{
  configuration = {
    imports = [ profile ];

    # Ativa a sessão alvo
    hamra.sessions.${sessionName} = lib.mkForce true;
    hamra.defaultSession = lib.mkForce sessionName;

    # Desativa sessões conflitantes
    hamra.sessions = lib.mkMerge (
      map (s: { ${s} = lib.mkForce false; }) disableSessions
    );
  };
}
