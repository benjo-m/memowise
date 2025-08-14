import { getUserStats } from "@/api/users";
import AnswerAccuracyRatioChart from "@/components/answer-accuracy-ratio-chart";
import SessionsByDayChart from "@/components/sessions-by-day-chart";
import TimesOfDayChart from "@/components/times-of-day-chart";
import Ionicons from "@expo/vector-icons/Ionicons";
import { useFocusEffect } from "@react-navigation/native";
import React, { useCallback, useState } from "react";
import { ActivityIndicator, ScrollView, Text, View } from "react-native";
import type { UserStats } from "../../../models/user-stats";

export default function StatsScreen() {
  const [stats, setStats] = useState<UserStats | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useFocusEffect(
    useCallback(() => {
      setLoading(true);
      setError(null);
      getUserStats()
        .then((data) => setStats(data))
        .catch(() => setError("Failed to load stats"))
        .finally(() => setLoading(false));
    }, [])
  );

  if (loading) {
    return (
      <View style={{ flex: 1, justifyContent: "center", alignItems: "center" }}>
        <ActivityIndicator />
      </View>
    );
  }

  if (error) {
    return (
      <View style={{ flex: 1, justifyContent: "center", alignItems: "center" }}>
        <Text style={{ color: "red" }}>{error}</Text>
      </View>
    );
  }

  if (!stats) return null;

  function formatTime(seconds: number) {
    const hours = Math.floor(seconds / 3600);
    const minutes = Math.floor((seconds % 3600) / 60);
    return `${hours}h ${minutes}m`;
  }

  return (
    <ScrollView contentContainerStyle={{ margin: 30 }}>
      <View
        style={{ flexDirection: "row", justifyContent: "space-between", marginBottom: 10, gap: 10 }}
      >
        <View
          style={{
            backgroundColor: "#ffffff",
            borderRadius: 15,
            padding: 15,
            alignItems: "center",
            flex: 1,
          }}
        >
          <Ionicons name="flame" size={28} color="#F97316" style={{ marginBottom: 5 }} />
          <Text style={{ fontSize: 18, fontWeight: "bold", marginBottom: 5 }}>
            {stats.current_study_streak}d
          </Text>
          <Text style={{ fontSize: 12, color: "#555" }}>Current</Text>
          <Text style={{ fontSize: 12, color: "#555" }}>study streak</Text>
        </View>

        <View
          style={{
            backgroundColor: "#ffffff",
            borderRadius: 15,
            padding: 15,
            alignItems: "center",
            flex: 1,
          }}
        >
          <Ionicons name="trophy" size={28} color="#EAB308" style={{ marginBottom: 5 }} />
          <Text style={{ fontSize: 18, fontWeight: "bold", marginBottom: 5 }}>
            {stats.longest_study_streak}d
          </Text>
          <Text style={{ fontSize: 12, color: "#555" }}>Longest</Text>
          <Text style={{ fontSize: 12, color: "#555" }}>study streak</Text>
        </View>

        <View
          style={{
            backgroundColor: "#ffffff",
            borderRadius: 15,
            padding: 15,
            alignItems: "center",
            flex: 1,
          }}
        >
          <Ionicons name="time" size={28} color="#2563EB" style={{ marginBottom: 5 }} />
          <Text style={{ fontSize: 18, fontWeight: "bold", marginBottom: 5 }}>
            {formatTime(stats.total_time_spent_studying)}
          </Text>
          <Text style={{ fontSize: 12, color: "#555" }}>Total</Text>
          <Text style={{ fontSize: 12, color: "#555" }}>time studied</Text>
        </View>
      </View>

      <View
        style={{
          backgroundColor: "#ffffff",
          padding: 15,
          borderRadius: 15,
          marginVertical: 10,
        }}
      >
        <Text style={{ fontSize: 18, fontWeight: "bold", marginBottom: 5 }}>Summary</Text>
        <Text style={{ fontSize: 14, color: "#374151", fontWeight: "500" }}>
          You’ve studied <Text style={{ fontWeight: "bold" }}>{stats.total_study_sessions}</Text>{" "}
          times, spending a total of{" "}
          <Text style={{ fontWeight: "bold" }}>{formatTime(stats.total_time_spent_studying)}</Text>{" "}
          learning.{"\n"}
          Your average study session lasts{" "}
          <Text style={{ fontWeight: "bold" }}>
            {Math.round(stats.average_session_duration / 60)}
          </Text>{" "}
          minutes, and you review about{" "}
          <Text style={{ fontWeight: "bold" }}>
            {stats.average_flashcards_reviewed_per_session.toFixed(1)}
          </Text>{" "}
          flashcards per session.{"\n"}
          {stats.favorite_deck ? (
            <>
              Your favorite deck is{" "}
              <Text style={{ fontWeight: "bold" }}>{stats.favorite_deck.deck}</Text>, which you’ve
              studied <Text style={{ fontWeight: "bold" }}>{stats.favorite_deck.count}</Text> times.
            </>
          ) : (
            <>You don’t have a favorite deck yet — time to start one!</>
          )}
        </Text>
      </View>

      <View style={{ marginVertical: 10 }}>
        <SessionsByDayChart data={stats.study_sessions_by_day} />
      </View>

      <View style={{ marginVertical: 10 }}>
        <TimesOfDayChart data={stats.study_sessions_by_part_of_day} />
      </View>

      <View style={{ marginVertical: 10, marginBottom: 30 }}>
        <AnswerAccuracyRatioChart
          correctAnswers={stats.total_correct_answers}
          incorrectAnswers={stats.total_incorrect_answers}
        />
      </View>
    </ScrollView>
  );
}
