/** @jsxImportSource @emotion/react */
import { css } from "@emotion/react";

const style = css`
    display: flex;
    justify-content: flex-end;
`;

const Header = ({ children }) => {
  return <div css={style}>{children}</div>;
};

export default Header;
