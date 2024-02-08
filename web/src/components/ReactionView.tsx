import { Tooltip } from "@mui/joy";
import classNames from "classnames";
import { memoServiceClient } from "@/grpcweb";
import useCurrentUser from "@/hooks/useCurrentUser";
import { MemoNamePrefix, useMemoStore } from "@/store/v1";
import { Memo } from "@/types/proto/api/v2/memo_service";
import { Reaction_Type } from "@/types/proto/api/v2/reaction_service";
import { User } from "@/types/proto/api/v2/user_service";

interface Props {
  memo: Memo;
  reactionType: Reaction_Type;
  users: User[];
}

export const stringifyReactionType = (reactionType: Reaction_Type): string => {
  switch (reactionType) {
    case Reaction_Type.EYES:
      return "👀";
    case Reaction_Type.HEART:
      return "💗";
    case Reaction_Type.LAUGH:
      return "😂";
    case Reaction_Type.ROCKET:
      return "🚀";
    case Reaction_Type.THUMBS_DOWN:
      return "👎";
    case Reaction_Type.THUMBS_UP:
      return "👍";
    default:
      return "";
  }
};

const stringifyUsers = (users: User[]): string => {
  if (users.length === 0) {
    return "";
  }
  if (users.length < 5) {
    return users.map((user) => user.nickname || user.username).join(", ");
  }
  return `${users
    .slice(0, 4)
    .map((user) => user.nickname || user.username)
    .join(", ")} and ${users.length - 4} others`;
};

const ReactionView = (props: Props) => {
  const { memo, reactionType, users } = props;
  const currenUser = useCurrentUser();
  const memoStore = useMemoStore();
  const hasReaction = users.some((user) => currenUser && user.username === currenUser.username);

  const handleReactionClick = async () => {
    if (!currenUser) {
      return;
    }

    const index = users.findIndex((user) => user.username === currenUser.username);
    try {
      if (index === -1) {
        await memoServiceClient.upsertMemoReaction({
          id: memo.id,
          reaction: {
            contentId: `${MemoNamePrefix}${memo.id}`,
            reactionType,
          },
        });
      } else {
        const reactions = memo.reactions.filter(
          (reaction) => reaction.reactionType === reactionType && reaction.creator === currenUser.name,
        );
        for (const reaction of reactions) {
          await memoServiceClient.deleteMemoReaction({ id: reaction.id });
        }
      }
    } catch (error) {
      // Skip error.
    }
    await memoStore.getOrFetchMemoById(memo.id, { skipCache: true });
  };

  return (
    <Tooltip title={stringifyUsers(users)} placement="top">
      <div
        className={classNames(
          "h-7 border px-2 py-0.5 rounded-full font-memo flex flex-row justify-center items-center gap-1 dark:border-zinc-700",
          currenUser && "cursor-pointer",
          hasReaction && "bg-blue-50 border-blue-100 dark:bg-zinc-900",
        )}
        onClick={handleReactionClick}
      >
        <span>{stringifyReactionType(reactionType)}</span>
        <span className="text-sm text-gray-500 dark:text-gray-400">{users.length}</span>
      </div>
    </Tooltip>
  );
};

export default ReactionView;
