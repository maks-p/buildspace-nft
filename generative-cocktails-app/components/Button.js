/** @jsxImportSource @emotion/react */
import { css } from "@emotion/react";

const buttonStyle = css`
  background-color: white;
  color: black;
  border: solid 1px black;
  padding: 5px;
  &:hover {
      cursor: pointer;
      transform: scale(1.025);
      transition: all 0.4s ease-in-out;
  }
`;

const Button = ({ text, onClick }) => {
  return (
    <div>
      <button css={buttonStyle} onClick={onClick}>
        {text}
      </button>
    </div>
  );
};

export default Button;
