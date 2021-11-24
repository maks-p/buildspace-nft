/** @jsxImportSource @emotion/react */
import { css } from "@emotion/react";

const style = css`
    margin: 100px 50px;
`;

const Container = ({ children }) => {
  return <div css={style}>{children}</div>;
};

export default Container;
