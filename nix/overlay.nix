final: prev: {
  tuxedo-control-center = final.callPackage ./tuxedo-control-center {};
  tuxedo-keyboard = final.callPackage ./tuxedo-keyboard {
    kernel = final.linux;
  };
}
