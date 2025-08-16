import { UserStats } from "@/models/user-stats";
import { createContext, useContext, useState } from "react";

type UserStatsContextType = {
  userStats: UserStats | null;
  setUserStats: React.Dispatch<React.SetStateAction<UserStats | null>>;
};

const UserStatsContext = createContext<UserStatsContextType | null>(null);

export const useUserStats = () => {
  const ctx = useContext(UserStatsContext);
  if (!ctx) throw new Error("useUserStats must be used within a UserStatsProvider");
  return ctx;
};

export const UserStatsProvider = ({ children }: { children: React.ReactNode }) => {
  const [userStats, setUserStats] = useState<UserStats | null>(null);

  return (
    <UserStatsContext.Provider value={{ userStats, setUserStats }}>
      {children}
    </UserStatsContext.Provider>
  );
};
