/// Anchor type for the NetworkKit framework target.
/// Named "NetworkKit" (not "Network") to avoid colliding with Apple's system Network.framework.
/// Real networking (URLSession client, request builders, interceptors) lands in a follow-up task.
public enum NetworkKitModule {}
