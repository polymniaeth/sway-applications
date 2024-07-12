import Link from "next/link";
import { useMedia } from "react-use";

export const ExternalFaucet = ({
  address,
  children,
}: {
  address?: string;
  children: React.ReactNode;
}) => {
  const isTablet = useMedia("(max-width: 768px)", false);

  return (
    <>
      {isTablet ? (
        <Link
          href={`https://faucet-testnet.fuel.network/?address=${address}`}
          target="_blank"
        >
          {children}
        </Link>
      ) : (
        { children }
      )}
    </>
  );
};
