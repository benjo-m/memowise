import { View } from "react-native";

type InputWrapperProps = {
  children: React.ReactNode;
  leadingIcon?: React.ReactNode;
  trailingIcon?: React.ReactNode;
};

export default function InputWrapper({ children, leadingIcon, trailingIcon }: InputWrapperProps) {
  return (
    <View
      style={[
        {
          backgroundColor: "#fff",
          borderRadius: 10,
          flexDirection: "row",
          justifyContent: "space-between",
          alignItems: "center",
        },
        leadingIcon ? { paddingLeft: 18 } : null,
        trailingIcon ? { paddingRight: 18 } : null,
      ]}
    >
      {leadingIcon}
      {children}
      {trailingIcon}
    </View>
  );
}
