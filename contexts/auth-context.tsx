import { signIn } from "@/api/auth";
import { useStorageState } from "@/hooks/useStorageState";
import { SplashScreen } from "expo-router";
import * as SecureStore from "expo-secure-store";
import { createContext, use, type PropsWithChildren } from "react";
SplashScreen.preventAutoHideAsync();

export type SignInResult = {
  success: boolean;
  error?: string;
  token?: string;
};

const AuthContext = createContext<{
  signIn: (email: string, password: string) => Promise<SignInResult> | null;
  signOut: () => void;
  session?: string | null;
  isLoading: boolean;
}>({
  signIn: () => null,
  signOut: () => null,
  session: null,
  isLoading: false,
});

export function useSession() {
  const value = use(AuthContext);
  if (!value) {
    throw new Error("useSession must be wrapped in a <SessionProvider />");
  }

  return value;
}

export function SessionProvider({ children }: PropsWithChildren) {
  const [[isLoading, session], setSession] = useStorageState("session");

  return (
    <AuthContext
      value={{
        signIn: async (email: string, password: string): Promise<SignInResult> => {
          try {
            const response = await signIn(email, password);
            if (response.token) {
              setSession(response.token);
              SecureStore.setItem("email", email);
            }
            return response;
          } catch (err) {
            console.error("Login error:", err);
            return { success: false, error: "Network or server error" };
          }
        },
        signOut: () => {
          setSession(null);
        },
        session,
        isLoading,
      }}
    >
      {children}
    </AuthContext>
  );
}
