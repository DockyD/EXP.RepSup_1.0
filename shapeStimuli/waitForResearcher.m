function waitForResearcher()

global G;

KbReleaseWait;

oldKeys = RestrictKeysForKbCheck(G.interrupt);

KbWait(G.keyboardNumber);
KbReleaseWait;

RestrictKeysForKbCheck(oldKeys);

end