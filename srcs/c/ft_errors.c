/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_errors.c                                        :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: bmoiroud <bmoiroud@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2017/10/16 16:15:27 by bmoiroud          #+#    #+#             */
/*   Updated: 2017/10/16 18:50:53 by bmoiroud         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "rt.h"

void	ft_error(int error)
{
	if (error == 0)
		ft_putstr("usage: ./rt <fichier>\n");
	else if (error == 1)
		ft_putstr("error: invalid file\n");
	else if (error == 2)
		ft_putstr("error: invalid scene\n");
	else if (error == 3)
		ft_putstr("malloc error\n");
	else if (error == 4)
		ft_putstr("thread creation error\n");
	else if (error == 5)
		ft_putstr("thread error\n");
	exit(EXIT_FAILURE);
}

long	errors(const int err, const char *comment)
{
	ft_putstr_fd("RT: ", 2);
	if (comment)
	{
		ft_putstr_fd(comment, 2);
		ft_putstr_fd(" ", 2);
	}
	if (err == ERR_SYS)
		ft_putendl_fd(strerror(errno), 2);
	else if (err == ERR_CL)
		ft_putstr_fd("OpenCL failure\n", 2);
	else if (err == ERR_SDL)
		ft_putendl_fd(SDL_GetError(), 2);
	else if (err == ERR_USAGE)
		ft_putendl_fd("\nUsage : ./"PROGRAM_NAME" scene.xml\n", 2);
	exit(EXIT_FAILURE);
	return (0);
}

void	cl_error_log(t_cl *cl, const cl_int error_code)
{
	char		log[MAX_ERR_LOG];

	ft_bzero(&log, sizeof(log));
	ft_putstr_fd("error code : ", 2);
	ft_putnbr_fd(error_code, 2);
	ft_putstr_fd("\n", 2);
	clGetProgramBuildInfo(cl->program, cl->device_id, \
		CL_PROGRAM_BUILD_LOG, MAX_ERR_LOG, &log, NULL);
	ft_putendl_fd(log, 2);
}
