import type { Badge } from "@/types/database";

interface BadgeCardProps {
  badge: Badge;
  earned?: boolean;
  earnedAt?: string;
}

export default function BadgeCard({
  badge,
  earned = false,
  earnedAt,
}: BadgeCardProps) {
  return (
    <div
      className={`flex flex-col items-center gap-2 p-4 rounded-xl border-2 transition-all ${
        earned
          ? "border-pink bg-light-pink shadow-md"
          : "border-gray-200 bg-gray-50 opacity-50 grayscale"
      }`}
    >
      <span className="text-4xl">{badge.icon_emoji ?? "🏅"}</span>
      <span
        className={`text-sm font-bold text-center leading-tight ${
          earned ? "text-brand-blue" : "text-gray-400"
        }`}
        style={{ fontFamily: "var(--font-bebas)" }}
      >
        {badge.name.toUpperCase()}
      </span>
      {earned && earnedAt && (
        <span className="text-xs text-gray-500">
          {new Date(earnedAt).toLocaleDateString("nl-BE", {
            day: "numeric",
            month: "short",
          })}
        </span>
      )}
      {!earned && (
        <span className="text-xs text-gray-400 text-center">
          {badge.description}
        </span>
      )}
    </div>
  );
}
