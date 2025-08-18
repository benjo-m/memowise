import CustomButton from "@/components/custom-button";
import { useSession } from "@/contexts/auth-context";
import colors from "@/styles/colors";
import { inputStyles } from "@/styles/inputs";
import Entypo from "@expo/vector-icons/Entypo";
import FontAwesome from "@expo/vector-icons/FontAwesome";
import MaterialCommunityIcons from "@expo/vector-icons/MaterialCommunityIcons";
import { useState } from "react";
import {
  Alert,
  ScrollView,
  StyleSheet,
  Text,
  TextInput,
  TouchableOpacity,
  View,
} from "react-native";

export default function SettingsScreen() {
  const { session, signOut } = useSession();
  const [answerOneVisible, setAnswerOneVisible] = useState<boolean>(false);
  const [answerTwoVisible, setAnswerTwoVisible] = useState<boolean>(false);
  const [answerThreeVisible, setAnswerThreeVisible] = useState<boolean>(false);

  return (
    <ScrollView contentContainerStyle={{ flexGrow: 1 }}>
      <View style={{ flex: 1, justifyContent: "space-between", margin: 30 }}>
        <View style={{ gap: 30 }}>
          <View>
            <Text
              style={{
                fontSize: 18,
                color: "#333",
                fontWeight: 700,
                marginBottom: 15,
              }}
            >
              Account
            </Text>
            <View style={{ gap: 10 }}>
              <TextInput style={inputStyles.base} defaultValue="cfokp@gmail.com"></TextInput>
              <CustomButton
                title={"Change email"}
                color={""}
                onPress={function (): void {
                  throw new Error("Function not implemented.");
                }}
                icon={<MaterialCommunityIcons name="email" size={18} color="white" />}
              ></CustomButton>
              <CustomButton
                title={"Change password"}
                color={""}
                onPress={function (): void {
                  throw new Error("Function not implemented.");
                }}
                icon={<Entypo name="dots-three-horizontal" size={18} color="white" />}
              ></CustomButton>
              <CustomButton
                title={"Delete account"}
                color={colors.red}
                onPress={function (): void {
                  throw new Error("Function not implemented.");
                }}
                icon={<FontAwesome name="user-times" size={18} color="white" />}
              ></CustomButton>
            </View>
          </View>
          <View>
            <Text
              style={{
                fontSize: 18,
                color: "#333",
                fontWeight: 700,
                marginBottom: 15,
              }}
            >
              About MemoWise
            </Text>
            <View style={{ gap: 10 }}>
              <TouchableOpacity
                onPress={() => setAnswerOneVisible((prev) => !prev)}
                style={styles.questionBox}
              >
                <View style={{ flexDirection: "row", justifyContent: "space-between" }}>
                  <Text style={styles.questionText}>What is MemoWise?</Text>
                  {answerOneVisible ? (
                    <FontAwesome name="chevron-up" size={14} color="#333" />
                  ) : (
                    <FontAwesome name="chevron-down" size={14} color="#333" />
                  )}
                </View>
                {answerOneVisible && (
                  <Text style={{ marginTop: 10 }}>
                    Lorem ipsum dolor sit amet consectetur, adipisicing elit. Ipsum excepturi ut rem
                    doloremque tenetur quae expedita, vel totam recusandae eos aliquam dolore quas
                    consequatur esse harum? Id vel soluta sequi!
                  </Text>
                )}
              </TouchableOpacity>

              <TouchableOpacity
                onPress={() => setAnswerTwoVisible((prev) => !prev)}
                style={styles.questionBox}
              >
                <View style={{ flexDirection: "row", justifyContent: "space-between" }}>
                  <Text style={styles.questionText}>How to use MemoWise?</Text>
                  {answerTwoVisible ? (
                    <FontAwesome name="chevron-up" size={14} color="#333" />
                  ) : (
                    <FontAwesome name="chevron-down" size={14} color="#333" />
                  )}
                </View>
                {answerTwoVisible && (
                  <Text style={{ marginTop: 10 }}>
                    Lorem ipsum dolor sit amet consectetur, adipisicing elit. Ipsum excepturi ut rem
                    doloremque tenetur quae expedita, vel totam recusandae eos aliquam dolore quas
                    consequatur esse harum? Id vel soluta sequi!
                  </Text>
                )}
              </TouchableOpacity>

              <TouchableOpacity
                onPress={() => setAnswerThreeVisible((prev) => !prev)}
                style={styles.questionBox}
              >
                <View style={{ flexDirection: "row", justifyContent: "space-between" }}>
                  <Text style={styles.questionText}>How does SM-2 algorithm work?</Text>
                  {answerThreeVisible ? (
                    <FontAwesome name="chevron-up" size={14} color="#333" />
                  ) : (
                    <FontAwesome name="chevron-down" size={14} color="#333" />
                  )}
                </View>
                {answerThreeVisible && (
                  <Text style={{ marginTop: 10 }}>
                    Lorem ipsum dolor sit amet consectetur, adipisicing elit. Ipsum excepturi ut rem
                    doloremque tenetur quae expedita, vel totam recusandae eos aliquam dolore quas
                    consequatur esse harum? Id vel soluta sequi!
                  </Text>
                )}
              </TouchableOpacity>
            </View>
          </View>
        </View>

        <View style={{ marginTop: 30 }}>
          <CustomButton
            title={"Sign out"}
            color="#8686ac9a"
            onPress={() => {
              Alert.alert(
                "Sign out",
                "Are you sure you want to sign out?",
                [
                  { text: "No", style: "cancel" },
                  { text: "Yes", onPress: () => signOut() },
                ],
                { cancelable: true }
              );
            }}
            icon={<MaterialCommunityIcons name="logout" size={18} color="white" />}
          ></CustomButton>
        </View>
      </View>
    </ScrollView>
  );
}

const styles = StyleSheet.create({
  questionBox: {
    backgroundColor: "white",
    paddingVertical: 16,
    paddingHorizontal: 10,
    borderRadius: 10,
  },
  questionText: {
    fontWeight: 500,
  },
});
