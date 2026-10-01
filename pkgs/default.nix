self: super: {
  opentripplanner = self.callPackage ./opentripplanner { };
  dmarc-report-viewer = self.callPackage ./dmarc-report-viewer { };
}
